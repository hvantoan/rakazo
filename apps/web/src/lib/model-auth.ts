import { waitForModelOAuthCompletion } from "@aas/core";
import { rpc } from "./rpc";

export type { ModelCatalogEntry, ModelCredential, ModelOAuthBegin } from "@aas/contracts";
export { cancelModelOAuthAttempt, finishModelOAuthAttempt } from "@aas/core";

export async function waitForModelOAuth(loginId: string, signal?: AbortSignal) {
  return waitForModelOAuthCompletion(() => rpc.models.completeOAuth({ loginId }, { signal }), {
    signal,
  });
}
