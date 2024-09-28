// require("dotenv").config();
const OpenAI = require("openai");
// let threadId = null;

const openai = new OpenAI({
  apiKey: process.env.OPENAI_API_KEY,
  organization: "org-FSuVnhJmnpoo2Z0dKeYXAzIj",
});

// Assistant variables
const asstID = "asst_XW6riICPege7OaEWC8wz3drt";
const threadID = "thread_bLAfoLKfTBGCTqtWrlvtdBuw";

// Bring it all together
async function main(question) {
  console.log("Pensando...");

  // Create a message
  await createMessage(question);

  // Create a run
  const run = await runThread();

  // Retrieve the current run
  let currentRun = await retrieveRun(threadID, run.id);

  // Keep Run status up to date
  // Poll for updates and check if run status is completed
  while (currentRun.status !== "completed") {
    await new Promise((resolve) => setTimeout(resolve, 1500));
    console.log(currentRun.status);
    currentRun = await retrieveRun(threadID, run.id);
  }

  // Get messages from the thread
  const { data } = await listMessages();
  console.log("Listo");
  // Display the last message for the current run
  return data[0].content[0].text.value;
}

/* -- Assistants API Functions -- */

// Create a message
async function createMessage(question) {
  const threadMessages = await openai.beta.threads.messages.create(threadID, {
    role: "user",
    content: question,
  });
}

// Run the thread / assistant
async function runThread() {
  const run = await openai.beta.threads.runs.create(threadID, {
    assistant_id: asstID,
    instructions: `Responde con datos, precedentes y artículos pertinentes a la pregunta, siempre indicando el número de artículo, registro digital o tesis referenciada. No puedes responder sin dar referencia. Responde solo con datos en archivos a tu disposición de las leyes en México. Responde con "Disculpa, no encontre nada relacionado al tema." si no encuentras nada.`,
  });
  return run;
}

// List thread Messages
async function listMessages() {
  return await openai.beta.threads.messages.list(threadID);
}

// Get the current run
async function retrieveRun(thread, run) {
  return await openai.beta.threads.runs.retrieve(thread, run);
}
module.exports = { main };
