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
exports.findModelInfo = exports.genSyntaxTree = exports.shutdown = exports.init = void 0;
var lang_service_1 = require("@ballerina/lang-service");
var vscode_uri_1 = require("vscode-uri");
var fs = require("fs");
var server;
var client;
var clientPromise = init();
function init() {
    return __awaiter(this, void 0, void 0, function () {
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    server = new lang_service_1.StdioBallerinaLangServer(process.env.BALLERINA_SDK_PATH);
                    server.start();
                    return [4 /*yield*/, lang_service_1.createStdioLangClient(server.lsProcess, function () { }, function () { })];
                case 1:
                    client = _a.sent();
                    if (!client) {
                        // tslint:disable-next-line:no-console
                        console.error("Could not initiate language client");
                    }
                    return [4 /*yield*/, client.init()];
                case 2:
                    _a.sent();
                    return [2 /*return*/];
            }
        });
    });
}
exports.init = init;
function shutdown() {
    client.close();
    server.shutdown();
}
exports.shutdown = shutdown;
function genSyntaxTree(balFilePath) {
    return __awaiter(this, void 0, void 0, function () {
        var syntaxTree, defaultDataFilePath, defaultDataContent, fileContent, tempBalFilePath, astResp, e_1;
        return __generator(this, function (_a) {
            switch (_a.label) {
                case 0:
                    _a.trys.push([0, 4, , 5]);
                    return [4 /*yield*/, clientPromise];
                case 1:
                    _a.sent();
                    defaultDataFilePath = balFilePath.substr(0, balFilePath.length - 10).concat("defaults.json");
                    try {
                        defaultDataContent = fs.readFileSync(defaultDataFilePath).toString();
                    }
                    catch (err) {
                        //This is handled later
                    }
                    fileContent = fs.readFileSync(balFilePath).toString();
                    tempBalFilePath = balFilePath;
                    // Commented since template
                    // if (defaultDataContent) {
                    //     fileContent = await getSampleSource(fileContent, JSON.parse(defaultDataContent));
                    //     tempBalFilePath = balFilePath.substr(0, balFilePath.length - 4).concat("_temp.bal")
                    //     fs.writeFileSync(tempBalFilePath, fileContent);
                    // }
                    return [4 /*yield*/, client.didOpen({
                            textDocument: {
                                uri: vscode_uri_1.default.file(tempBalFilePath).toString(),
                                languageId: "ballerina",
                                text: fileContent,
                                version: 1
                            }
                        })];
                case 2:
                    // Commented since template
                    // if (defaultDataContent) {
                    //     fileContent = await getSampleSource(fileContent, JSON.parse(defaultDataContent));
                    //     tempBalFilePath = balFilePath.substr(0, balFilePath.length - 4).concat("_temp.bal")
                    //     fs.writeFileSync(tempBalFilePath, fileContent);
                    // }
                    _a.sent();
                    return [4 /*yield*/, client.getSyntaxTree({
                            documentIdentifier: { uri: vscode_uri_1.default.file(tempBalFilePath).toString() }
                        })];
                case 3:
                    astResp = _a.sent();
                    syntaxTree = astResp.syntaxTree;
                    return [3 /*break*/, 5];
                case 4:
                    e_1 = _a.sent();
                    // tslint:disable-next-line:no-console
                    console.log("Error when parsing " + balFilePath + " \n " + e_1);
                    return [3 /*break*/, 5];
                case 5: return [2 /*return*/, syntaxTree];
            }
        });
    });
}
exports.genSyntaxTree = genSyntaxTree;
function findModelInfo(node, modelInfo) {
    if (modelInfo === void 0) { modelInfo = {}; }
    if (!modelInfo[node.kind]) {
        modelInfo[node.kind] = {
            __count: 0,
        };
    }
    var model = modelInfo[node.kind];
    model.__count++;
    Object.keys(node).forEach(function (key) {
        if (["kind", "id", "position", "source", "typeData"].includes(key)) {
            // These properties are in the interface STNode
            // Other interfaces we generate extends it, so no need to add it.
            return;
        }
        var value = node[key];
        if (model[key] === undefined) {
            model[key] = {
                __count: 0,
                type: {},
            };
        }
        var property = model[key];
        property.__count++;
        if (value.kind) {
            property.type[value.kind] = true;
            findModelInfo(value, modelInfo);
            return;
        }
        if (Array.isArray(value)) {
            var types_1 = {};
            value.forEach(function (valueEl) {
                if (valueEl.kind) {
                    types_1[valueEl.kind] = true;
                    findModelInfo(valueEl, modelInfo);
                    return;
                }
                if (["boolean", "string", "number"].includes(typeof valueEl)) {
                    types_1[typeof valueEl] = true;
                }
                else {
                    types_1.any = true;
                }
            });
            if (property.elementTypes) {
                Object.assign(types_1, property.elementTypes);
            }
            property.elementTypes = types_1;
            return;
        }
        if (["boolean", "string", "number"].includes(typeof value)) {
            property.type[typeof value] = true;
        }
        else {
            property.type.any = true;
        }
    });
    return modelInfo;
}
exports.findModelInfo = findModelInfo;
//# sourceMappingURL=lang-client.js.map