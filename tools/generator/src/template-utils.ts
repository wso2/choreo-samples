import { compile } from "handlebars";

export async function getSampleSource(sampleContent: string, config: {[key: string]: any}) {
    const hbTemplate = compile(sampleContent);
    return hbTemplate(config);
}