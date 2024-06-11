const express = require("express");
const app = express();
const port = 8080;
const path = require("path");
const mysql2 = require("mysql2");
const bodyParser = require("body-parser");
const fs = require("fs");
const uuid = require("uuid");

const pool = mysql2.createPool(
  !process.env.MYSQL_ADDON_URI
    ? "mysql://root:root@localhost:3306/solodyankin"
    : process.env.MYSQL_ADDON_URI
);

app.use(bodyParser.json({ limit: "100mb" }));

const sendHTML = (page, res) => {
  const file = path.join(__dirname, "../page", `${page}.html`);
  fs.existsSync(file)
    ? res.status(200).sendFile(file)
    : res
        .status(200)
        .sendFile(path.join(__dirname, "../page", `authorization.html`));
};

app.get("/", (req, res) => {
  sendHTML(req.url, res);
});

app.get("/api/checkSession", (req, res) => {
  const session = req.query.session;
  if (!session) {
    res.status(400).send({ message: "Нет сессии в параметрах!" });
  } else {
    pool.getConnection((err, connection) => {
      if (connection) {
        connection.query(
          `SELECT * FROM sessions WHERE session = "${session}"`,
          (error, result) => {
            console.log(result);
            if (error) {
              res.status(500).send({ error, message: error.sqlMessage });
            } else if (result) {
              result.length > 0
                ? res.status(200).send({ message: "Welcome!" })
                : res.status(400).send({ message: "Сессия не существует!" });
            }
          }
        );
        connection.release();
      } else if (err) {
        res.status(500).json({ err, message: err.message });
        console.log(err);
      }
    });
  }
});

app.delete("/api/deleteSession", (req, res) => {
  const session = req.query.session;
  if (!session) {
    res.status(404).send({ message: "Не указана сессия или неверный формат!" });
    return;
  }
  pool.getConnection((err, connection) => {
    if (connection) {
      connection.query(
        `DELETE FROM sessions WHERE session = '${session}'`,
        (err, result) => {
          console.log(result);
          if (err) res.status(500).send({ err, message: err.sqlMessage });
          else if (result)
            res.status(200).send({ result, message: "Вы успешно вышли!" });
        }
      );
      connection.release();
    } else if (err) {
      res.status(500).json({ error: err, err: err.message });
      console.log(err);
    }
  });
});

app.post("/api/login", (req, res) => {
  pool.getConnection((err, connection) => {
    if (connection) {
      connection.query(
        `SELECT * FROM users WHERE BINARY login = "${req.body.login}" AND BINARY password = "${req.body.password}"`,
        (error, result) => {
          if (error) res.status(500).json({ error, message: error.sqlMessage });
          else if (result) {
            let session = uuid.v4();
            result.length > 0
              ? connection.query(
                  `INSERT INTO sessions (userId, session) VALUES (${result[0].id}, "${session}")`,
                  (notCreated, created) => {
                    created && res.status(200).json({ session: session });
                    notCreated &&
                      res
                        .status(500)
                        .json({ notCreated, message: notCreated.sqlMessage });
                  }
                )
              : res.status(400).json({
                  result,
                  message: `Неправильно введен логин: "${req.body.login}" или пароль: "${req.body.password}"!`,
                });
          }
        }
      );
      connection.release();
    } else if (err) {
      res.status(500).json({ err, message: err.message });
      console.log(err);
    }
  });
});

app.use((req, res) => {
  sendHTML(req.url, res);
});

app.listen(port, () => {
  console.log(`Example app listening on port http://localhost:${port}`);
});
