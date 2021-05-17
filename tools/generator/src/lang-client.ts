import { createStdioLangClient, StdioBallerinaLangServer } from "@ballerina/lang-service";
import { ChildProcess } from "child_process";
import URI from "vscode-uri";
import * as fs from "fs";
import { getSampleSource } from "./template-utils";

let server: any;
let client: any;

const clientPromise = init();

export async function init() {
    server = new StdioBallerinaLangServer(process.env.BALLERINA_SDK_PATH);
    server.start();
    client = await createStdioLangClient(server.lsProcess as ChildProcess, () => {/**/}, () => {/**/});
    if (!client) {
        // tslint:disable-next-line:no-console
        console.error("Could not initiate language client");
    }

    await client.init();
}

export function shutdown() {
    client.close();
    server.shutdown();
}

export async function genSyntaxTree(balFilePath: string) {
    let syntaxTree;
    try {
        await clientPromise;
        const defaultDataFilePath = balFilePath.substr(0, balFilePath.length - 10).concat("defaults.json");
        var defaultDataContent;
        try { 
            defaultDataContent = fs.readFileSync(defaultDataFilePath).toString();
        } catch (err) {
            //This is handled later
        }
        var fileContent = fs.readFileSync(balFilePath).toString();
        var tempBalFilePath = balFilePath;
        // Commented since template
        // if (defaultDataContent) {
        //     fileContent = await getSampleSource(fileContent, JSON.parse(defaultDataContent));
        //     tempBalFilePath = balFilePath.substr(0, balFilePath.length - 4).concat("_temp.bal")
        //     fs.writeFileSync(tempBalFilePath, fileContent);
        // }
        await client.didOpen({
            textDocument: {
                uri: URI.file(tempBalFilePath).toString(),
                languageId: "ballerina",
                text: fileContent,
                version: 1
            }
        });
        const astResp = await client.getSyntaxTree({
            documentIdentifier: { uri: URI.file(tempBalFilePath).toString() }
        });
        syntaxTree = astResp.syntaxTree;
    } catch (e) {
        // tslint:disable-next-line:no-console
        console.log(`Error when parsing ${balFilePath} \n ${e}`);
    }
    return syntaxTree;
}

export function findModelInfo(node: any, modelInfo: any = {}) {
    if (!modelInfo[node.kind]) {
        modelInfo[node.kind] = {
            __count: 0,
        };
    }
    const model = modelInfo[node.kind];
    model.__count++;

    Object.keys(node).forEach((key) => {
        if (["kind", "id", "position", "source", "typeData"].includes(key)) {
            // These properties are in the interface STNode
            // Other interfaces we generate extends it, so no need to add it.
            return;
        }

        const value = (node as any)[key];

        if (model[key] === undefined) {
            model[key] = {
                __count: 0,
                type: {},
            };
        }
        const property = model[key];
        property.__count++;

        if (value.kind) {
            property.type[value.kind] = true;
            findModelInfo(value, modelInfo);
            return;
        }

        if (Array.isArray(value)) {
            const types: any = {};
            value.forEach((valueEl) => {
                if (valueEl.kind) {
                    types[valueEl.kind] = true;
                    findModelInfo(valueEl, modelInfo);
                    return;
                }

                if (["boolean", "string", "number"].includes(typeof valueEl)) {
                    types[typeof valueEl] = true;
                } else {
                    types.any = true;
                }
            });
            if (property.elementTypes) {
                Object.assign(types, property.elementTypes);
            }
            property.elementTypes = types;
            return;
        }

        if (["boolean", "string", "number"].includes(typeof value)) {
            property.type[typeof value] = true;
        } else {
            property.type.any = true;
        }
    });

    return modelInfo;
}