import { ChildProcess } from "child_process";

export interface IBallerinaLangServer {
    start: () => void;
    shutdown: () => void;
    lsProcess?: ChildProcess;
}
