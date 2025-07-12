import * as admin from "firebase-admin";

// Inicializa o Firebase Admin SDK
admin.initializeApp();

// Exporta as funções de outros arquivos
// Exemplo: export * from "./auth/auth";
export * from "./audit/audit";
export * from "./wallet/wallet";
