import { exec } from "child_process";
import * as fs from "fs";
import * as path from "path";
import { findModelInfo, genSyntaxTree, shutdown } from "./lang-client";

const sdkPath = process.env.BALLERINA_SDK_PATH;

if (!sdkPath) {
    // tslint:disable-next-line:no-console
    console.log("please define BALLERINA_SDK_PATH");
    process.exit(1);
}

const modelInfo: any = {};

const servicesPath = "../../../samples/services";
const integrationsPath = "../../../samples/integrations";
const balFiles: string[] = [];
const triedBalFiles: string[] = [];
const notParsedBalFiles: string[] = [];
const usedBalFiles: string[] = [];
const timedOutBalFiles: string[] = [];

async function loadFiles() {
    //Load services
    fs.readdirSync(path.join(__dirname, servicesPath))
    .filter(function(file) {
        return !file.includes(".");
    })
    .forEach(function(file) {
        balFiles.push(path.join(__dirname, servicesPath, file, "sample.bal"));
    });
    //Load Integration
    fs.readdirSync(path.join(__dirname, integrationsPath))
    .filter(function(file) {
        return !file.includes(".");
    })
    .forEach(function(file) {
        balFiles.push(path.join(__dirname, integrationsPath, file, "sample.bal"));
    });
}

loadFiles();
processPart(0, 100);

function printSummary() {
    const { log } = console;
    const found = balFiles.length;
    const notParsed = notParsedBalFiles.length;
    const used = usedBalFiles.length;
    const timedOut = timedOutBalFiles.length;

    log(`${found} Files found`);
    log(`${notParsed} Could not be parsed`);
    log(`${used} Used for util generation`);
    log(`${timedOut} timed out while parsing`);
}

function processPart(start: number, count: number) {
    const syntaxTreePromises: any[] = [];
    const filesPart = balFiles.slice(start, start + count);
    filesPart.forEach((file) => {
        triedBalFiles.push(file);
        const promise = genSyntaxTree(file).then((syntaxTree) => {
            // tslint:disable-next-line: no-console
            //console.log(syntaxTree);
            if (!syntaxTree || Object.keys(syntaxTree).length === 0) {
                // could not parse
                // tslint:disable-next-line: no-console
                console.log(" Could not parse " + file);
                notParsedBalFiles.push(file);
                process.exit(1);
            }
            usedBalFiles.push(file);
            findModelInfo(syntaxTree, modelInfo);
            const stFilePath = file.substr(0, file.length - 4).concat(".json");
            fs.writeFileSync(stFilePath, JSON.stringify(syntaxTree, null, 2));
        }).catch((err) => {
            notParsedBalFiles.push(file);
            // tslint:disable-next-line: no-console
            console.log(err);
        });

        const timeout = new Promise((resolve, reject) => {
            setTimeout(() => {
                timedOutBalFiles.push(file);
                resolve(undefined);
            }, 20000);
        });
        syntaxTreePromises.push(Promise.race([promise, timeout]));
    });
    Promise.all(syntaxTreePromises).then(() => {
        if (syntaxTreePromises.length < count) {
            printSummary();
            shutdown();
            return;
        }

        processPart(start + count, count);
    });
}