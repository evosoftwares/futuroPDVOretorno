import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

export const addAuditLog = functions.https.onCall(async (data, context) => {
  // Validação de autenticação
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "A função deve ser chamada por um usuário autenticado."
    );
  }

  // Validação dos dados recebidos
  if (typeof data !== 'object' || data === null) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Os dados devem ser um objeto."
    );
  }

  const { action, targetId, targetType } = data;
  if (!action || !targetId || !targetType) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "Dados insuficientes para o log de auditoria."
    );
  }

  const auditData = {
    ...data,
    performedBy: context.auth.uid,
    timestamp: admin.firestore.FieldValue.serverTimestamp(),
    // Adicionar mais contexto, como IP, se necessário (disponível em context.rawRequest)
  };

  try {
    await admin.firestore().collection("auditLogs").add(auditData);
    return { success: true, message: "Log de auditoria adicionado." };
  } catch (error) {
    console.error("Erro ao adicionar log de auditoria:", error);
    throw new functions.https.HttpsError(
      "internal",
      "Erro interno ao salvar o log."
    );
  }
});
