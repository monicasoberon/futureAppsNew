//chatGPTSchema.js
// Initialize threadId outside the function so it can persist across function calls
const OpenAI = require("openai");

let threadId = null;

async function askQuestion(question) {
  const openai = new OpenAI({
    apiKey: process.env.OPENAI_API_KEY,
    organization: "org-proj_nG7m0i26MwEqn3aTeTMKQBra",
    project: "$Bufetec",
  });

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

  return new Promise((resolve, reject) => {
    let response = "";

    // Stream assistant's response
    const run = openai.beta.threads.runs
      .stream(threadId, {
        assistant_id: "asst_XW6riICPege7OaEWC8wz3drt", // Replace with the actual assistant ID
      })
      .on("textCreated", (text) => {
        response += text;
      })
      .on("textDelta", (textDelta) => {
        response += textDelta.value;
      })
      .on("end", () => {
        resolve(response);
      })
      .on("error", (error) => {
        reject(error);
      });
  });
}

module.exports = { askQuestion };
