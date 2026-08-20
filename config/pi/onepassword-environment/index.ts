import { createClient, DesktopAuth } from "@1password/sdk";
import type { ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { readFile } from "node:fs/promises";
import { fileURLToPath } from "node:url";

const CONFIG_PATH = fileURLToPath(new URL("./config.json", import.meta.url));
const INTEGRATION_NAME = "Pi Environment Loader";
const INTEGRATION_VERSION = "1.0.0";
const STATUS_KEY = "onepassword-environment";
const REQUIRED_KEYS = ["EXA_API_KEY", "TAVILY_API_KEY", "FIRECRAWL_API_KEY"] as const;

type Config = {
  account: string;
  environmentId: string;
};

async function readConfig(): Promise<Config> {
  const parsed = JSON.parse(await readFile(CONFIG_PATH, "utf8")) as Partial<Config>;
  const account = typeof parsed.account === "string" ? parsed.account.trim() : "";
  const environmentId = typeof parsed.environmentId === "string" ? parsed.environmentId.trim() : "";

  if (!account) throw new Error(`Set account in ${CONFIG_PATH}`);
  if (!environmentId) throw new Error(`Set environmentId in ${CONFIG_PATH}`);

  return { account, environmentId };
}

export default function onePasswordEnvironment(pi: ExtensionAPI) {
  async function loadEnvironment(ctx: ExtensionContext): Promise<void> {
    // Fail closed instead of retaining a credential that was removed or rotated.
    for (const key of REQUIRED_KEYS) delete process.env[key];

    const config = await readConfig();
    const client = await createClient({
      auth: new DesktopAuth(config.account),
      integrationName: INTEGRATION_NAME,
      integrationVersion: INTEGRATION_VERSION,
    });
    const response = await client.environments.getVariables(config.environmentId);
    const variables = new Map(response.variables.map(({ name, value }) => [name, value]));
    const missing = REQUIRED_KEYS.filter((key) => !variables.get(key)?.trim());

    if (missing.length > 0) {
      throw new Error(`Missing variables in the 1Password Pi Environment: ${missing.join(", ")}`);
    }

    for (const key of REQUIRED_KEYS) process.env[key] = variables.get(key)!;

    ctx.ui.setStatus(STATUS_KEY, "1Password ✓");
    ctx.ui.notify("Loaded web credentials from the 1Password Pi Environment", "info");
  }

  async function loadSafely(ctx: ExtensionContext): Promise<void> {
    try {
      await loadEnvironment(ctx);
    } catch (error) {
      ctx.ui.setStatus(STATUS_KEY, "1Password ✗");
      ctx.ui.notify(error instanceof Error ? error.message : String(error), "error");
    }
  }

  pi.on("session_start", async (event, ctx) => {
    if (event.reason === "startup" || event.reason === "reload") await loadSafely(ctx);
  });
}
