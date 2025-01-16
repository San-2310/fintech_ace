const express = require("express");
const fs = require("fs");
const bodyParser = require("body-parser");
const cors = require("cors");

const app = express();
const PORT = 3000;

app.use(cors());
app.use(bodyParser.json());

// Helper function to read data from JSON files
const readData = (fileName) => {
  const data = fs.readFileSync(`./data/${fileName}`, "utf-8");
  return JSON.parse(data);
};

// Helper function to write data to JSON files
const writeData = (fileName, data) => {
  fs.writeFileSync(
    `./data/${fileName}`,
    JSON.stringify(data, null, 2),
    "utf-8"
  );
};

// Routes
// 1. Savings
app.get("/savings", (req, res) => {
  const savings = readData("savings.json");
  res.json(savings);
});

app.post("/savings", (req, res) => {
  const savings = readData("savings.json");
  const newSaving = { id: Date.now().toString(), ...req.body };
  savings.push(newSaving);
  writeData("savings.json", savings);
  res.status(201).json(newSaving);
});

// 2. Loans
app.get("/loans", (req, res) => {
  const loans = readData("loans.json");
  res.json(loans);
});

app.post("/loans", (req, res) => {
  const loans = readData("loans.json");
  const newLoan = { id: Date.now().toString(), status: "pending", ...req.body };
  loans.push(newLoan);
  writeData("loans.json", loans);
  res.status(201).json(newLoan);
});

// 3. Insurance
app.get("/insurance", (req, res) => {
  const insurance = readData("insurance.json");
  res.json(insurance);
});

app.post("/insurance", (req, res) => {
  const insurance = readData("insurance.json");
  const newPolicy = {
    id: Date.now().toString(),
    status: "active",
    ...req.body,
  };
  insurance.push(newPolicy);
  writeData("insurance.json", insurance);
  res.status(201).json(newPolicy);
});

// 4. Transactions
app.get("/transactions", (req, res) => {
  const transactions = readData("transactions.json");
  res.json(transactions);
});

// 4. Transactions
app.get("/recenttransactions", (req, res) => {
  const transactions = readData("transactions.json");
  // Sort transactions by descending order of ID (timestamp) and return the top 3
  const sortedTransactions = transactions
    .sort((a, b) => b.id - a.id)
    .slice(0, 3);
  res.json(sortedTransactions);
});
app.post("/transactions", (req, res) => {
  const transactions = readData("transactions.json");
  const newTransaction = {
    id: Date.now().toString(),
    status: "success",
    ...req.body,
  };
  transactions.push(newTransaction);
  writeData("transactions.json", transactions);
  res.status(201).json(newTransaction);
});

// 5. Users
app.get("/users", (req, res) => {
  const users = readData("users.json");
  res.json(users);
});

app.post("/users", (req, res) => {
  const users = readData("users.json");
  const newUser = { id: Date.now().toString(), ...req.body };
  users.push(newUser);
  writeData("users.json", users);
  res.status(201).json(newUser);
});

// Start server
app.listen(PORT, () => {
  console.log(`Mock Banking API is running on http://localhost:${PORT}`);
});
