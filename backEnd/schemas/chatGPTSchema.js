//chatGPTSchema.js
require("dotenv").config();
// Initialize threadId outside the function so it can persist across function calls
const OpenAI = require("openai");
let threadId = null;

const key = process.env.OPENAI_API_KEY;

async function askQuestion(question) {
  const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
    organization: process.env.OPENAI_ORG, //nuestra org
    project: "proj_nG7m0i26MwEqn3aTeTMKQBra", //bufetec
  });

  const assistant = await openai.beta.assistants.retrieve(
    "asst_XW6riICPege7OaEWC8wz3drt"
  );
  // Check if a thread already exists
  if (!threadId) {
    const thread = await openai.beta.threads.create();
    threadId = thread.id; // Store the thread ID
  }

  // Send the message to the existing thread
  const message = await openai.beta.threads.messages.create(threadId, {
    role: "user",
    content: question,
  });

  const run = await openai.beta.threads.runs.create(threadId, {
    assistant_id: assistant.id,
    instructions:
      "Responde si encuentras información relacionada, o solo informa que no encontraste nada relevante.",
  });
}

module.exports = { askQuestion };
