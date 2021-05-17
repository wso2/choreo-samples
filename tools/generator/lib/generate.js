"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __generator = (this && this.__generator) || function (thisArg, body) {
    var _ = { label: 0, sent: function() { if (t[0] & 1) throw t[1]; return t[1]; }, trys: [], ops: [] }, f, y, t, g;
    return g = { next: verb(0), "throw": verb(1), "return": verb(2) }, typeof Symbol === "function" && (g[Symbol.iterator] = function() { return this; }), g;
    function verb(n) { return function (v) { return step([n, v]); }; }
    function step(op) {
        if (f) throw new TypeError("Generator is already executing.");
        while (_) try {
            if (f = 1, y && (t = op[0] & 2 ? y["return"] : op[0] ? y["throw"] || ((t = y["return"]) && t.call(y), 0) : y.next) && !(t = t.call(y, op[1])).done) return t;
            if (y = 0, t) op = [op[0] & 2, t.value];
            switch (op[0]) {
                case 0: case 1: t = op; break;
                case 4: _.label++; return { value: op[1], done: false };
                case 5: _.label++; y = op[1]; op = [0]; continue;
                case 7: op = _.ops.pop(); _.trys.pop(); continue;
                default:
                    if (!(t = _.trys, t = t.length > 0 && t[t.length - 1]) && (op[0] === 6 || op[0] === 2)) { _ = 0; continue; }
                    if (op[0] === 3 && (!t || (op[1] > t[0] && op[1] < t[3]))) { _.label = op[1]; break; }
                    if (op[0] === 6 && _.label < t[1]) { _.label = t[1]; t = op; break; }
                    if (t && _.label < t[2]) { _.label = t[2]; _.ops.push(op); break; }
                    if (t[2]) _.ops.pop();
                    _.trys.pop(); continue;
            }
            op = body.call(thisArg, _);
        } catch (e) { op = [6, e]; y = 0; } finally { f = t = 0; }
        if (op[0] & 5) throw op[1]; return { value: op[0] ? op[1] : void 0, done: true };
    }
};
Object.defineProperty(exports, "__esModule", { value: true });
var fs = require("fs");
var path = require("path");
var lang_client_1 = require("./lang-client");
var sdkPath = process.env.BALLERINA_SDK_PATH;
if (!sdkPath) {
    // tslint:disable-next-line:no-console
    console.log("please define BALLERINA_SDK_PATH");
    process.exit(1);
}
var modelInfo = {};
var servicesPath = "../../../samples/services";
var integrationsPath = "../../../samples/integrations";
var balFiles = [];
var triedBalFiles = [];
var notParsedBalFiles = [];
var usedBalFiles = [];
var timedOutBalFiles = [];
function loadFiles() {
    return __awaiter(this, void 0, void 0, function () {
        return __generator(this, function (_a) {
            //Load services
            fs.readdirSync(path.join(__dirname, servicesPath))
                .filter(function (file) {
                return !file.includes(".");
            })
                .forEach(function (file) {
                balFiles.push(path.join(__dirname, servicesPath, file, "sample.bal"));
            });
            //Load Integration
            fs.readdirSync(path.join(__dirname, integrationsPath))
                .filter(function (file) {
                return !file.includes(".");
            })
                .forEach(function (file) {
                balFiles.push(path.join(__dirname, integrationsPath, file, "sample.bal"));
            });
            return [2 /*return*/];
        });
    });
}
loadFiles();
processPart(0, 100);
function printSummary() {
    var log = console.log;
    var found = balFiles.length;
    var notParsed = notParsedBalFiles.length;
    var used = usedBalFiles.length;
    var timedOut = timedOutBalFiles.length;
    log(found + " Files found");
    log(notParsed + " Could not be parsed");
    log(used + " Used for util generation");
    log(timedOut + " timed out while parsing");
}
function processPart(start, count) {
    var syntaxTreePromises = [];
    var filesPart = balFiles.slice(start, start + count);
    filesPart.forEach(function (file) {
        triedBalFiles.push(file);
        var promise = lang_client_1.genSyntaxTree(file).then(function (syntaxTree) {
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
            lang_client_1.findModelInfo(syntaxTree, modelInfo);
            var stFilePath = file.substr(0, file.length - 4).concat(".json");
            fs.writeFileSync(stFilePath, JSON.stringify(syntaxTree, null, 2));
        }).catch(function (err) {
            notParsedBalFiles.push(file);
            // tslint:disable-next-line: no-console
            console.log(err);
        });
        var timeout = new Promise(function (resolve, reject) {
            setTimeout(function () {
                timedOutBalFiles.push(file);
                resolve(undefined);
            }, 20000);
        });
        syntaxTreePromises.push(Promise.race([promise, timeout]));
    });
    Promise.all(syntaxTreePromises).then(function () {
        if (syntaxTreePromises.length < count) {
            printSummary();
            lang_client_1.shutdown();
            return;
        }
        processPart(start + count, count);
    });
}
//# sourceMappingURL=generate.js.map