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
          `SELECT users.id, users.name, roles.name AS "role" FROM users 
          JOIN sessions ON users.id = sessions.userId
          JOIN roles ON roles.id = users.roleId WHERE sessions.session = "${session}"`,
          (error, result) => {
            console.log(result);
            if (error) {
              res.status(500).send({ error, message: error.sqlMessage });
            } else if (result) {
              console.log(result);
              result.length > 0
                ? res
                    .status(200)
                    .send({ result, message: `Welcome, ${result[0].name}!` })
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

app.get("/api/users", (req, res) => {
  pool.getConnection((err, connection) => {
    if (connection) {
      connection.query(
        `SELECT users.id, users.name, users.login, users.password, post.name AS 'post', departments.name AS "department", roles.name AS "role" 
        FROM users JOIN departments ON users.departmentId = departments.id JOIN roles ON users.roleId = roles.id JOIN post ON users.postId = post.id`,
        (error, result) => {
          if (error) res.status(500).json({ err, message: error.sqlMessage });
          else if (result)
            result.length > 0
              ? res
                  .status(200)
                  .json({ result, message: "Пользователи получены!" })
              : res.status(400).json({ result, message: "Нет пользователей!" });
        }
      );
      connection.release();
    } else if (err) {
      res.status(500).json({ err, message: err.message });
      console.log(err);
    }
  });
});

app.get("/api/users/parameters", (req, res) => {
  pool.getConnection((err, connection) => {
    if (connection) {
      departments = connection.query(
        `SELECT departments.id AS "departmentsId", departments.name AS "department" FROM departments`,
        (error, result) => {
          if (error) res.status(500).json({ error, message: error.sqlMessage });
          else if (result) {
            result.length > 0
              ? connection.query(
                  `SELECT roles.id AS "roleId", roles.name AS "role" FROM roles  `,
                  (errror, roles) => {
                    if (errror)
                      res
                        .status(500)
                        .json({ errror, message: errror.sqlMessage });
                    else if (roles)
                      roles.length > 0
                        ? connection.query(
                            `SELECT post.id AS "postId", post.name AS "role" FROM post`,
                            (isError, posts) => {
                              if (isError)
                                res.status(500).json({
                                  isError,
                                  message: isError.sqlMessage,
                                });
                              else if (posts) {
                                posts.length > 0
                                  ? res.status(200).json({
                                      departments: result,
                                      roles: roles,
                                      posts: posts,
                                      message:
                                        "Отделы, роли и должности успешно получены!",
                                    })
                                  : res.status(400).json({
                                      departments: result,
                                      roles: roles,
                                      message:
                                        "Отделы, роли успешно получены, но должностей нет!",
                                    });
                              }
                            }
                          )
                        : res.status(400).json({
                            departments: result,
                            roles: roles,
                            message: "Отделы успешно получены, но ролей нет!",
                          });
                  }
                )
              : res.status(400).json({ result, message: "Отделов нет!" });
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

app.post("/api/users/create", (req, res) => {
  console.log(req.body);
  pool.getConnection((err, connection) => {
    if (connection) {
      connection.query(
        `INSERT INTO users (name, login, password, departmentId, roleId, postId) 
        VALUES("${req.body.name}", "${req.body.login}", "${req.body.password}", "${req.body.department}", "${req.body.role}", "${req.body.post}")`,
        (error, result) => {
          if (error) res.status(500).json({ error, message: error.sqlMessage });
          else if (result)
            res.status(200).json({
              message: `Пользователь ${req.body.login} успешно добавлен!`,
            });
        }
      );
      connection.release();
    } else if (err) {
      res.status(500).json({ err, message: err.message });
    }
  });
});

app.delete("/api/users/delete", (req, res) => {
  if (!req.query.id) {
    res.status(404).json({ message: "Id обязательно!" });
    return;
  }

  pool.getConnection((err, connection) => {
    if (connection) {
      connection.query(
        `DELETE t1, t2 
        FROM users t1 
        LEFT JOIN sessions t2 ON t1.id = t2.userId 
        WHERE t1.id =  ${req.query.id}`,
        (error, result) => {
          if (error) {
            res.status(500).json({ error, message: error.sqlMessage });
          } else if (result) {
            res
              .status(200)
              .json({ result, message: "Пользователь успешно удален!" });
          }
        }
      );
      connection.release();
    } else if (err) {
      res.status(500).json({ err, message: err.message });
    }
  });
});

app.get("/api/tickets/parameters", (req, res) => {
  pool.getConnection((err, connection) => {
    if (connection) {
      connection.query(`SELECT * FROM activ`, (error, result) => {
        if (error) {
          res.status(500).json({ error, message: error.sqlMessage });
        } else if (result) {
          result.length > 0
            ? connection.query(
                `SELECT * FROM categorys`,
                (isError, categorys) => {
                  if (isError)
                    res
                      .status(500)
                      .json({ isError, message: isError.sqlMessage });
                  else if (categorys) {
                    categorys.length > 0
                      ? res.status(200).json({
                          activ: result,
                          categorys,
                          message: "Кабинеты и категории найдены!",
                        })
                      : res.status(400).json({
                          activ: result,
                          categorys,
                          message: "Кабинеты найдены, но категории пусты!",
                        });
                  }
                }
              )
            : res.status(400).json({ result, message: "Кабинеты не найдены!" });
        }
      });
      connection.release();
    } else if (err) {
      res.status(500).json({ err, message: err.message });
    }
  });
});

app.post("/api/tickets/create", (req, res) => {
  pool.getConnection((err, connection) => {
    if (connection) {
      connection.query(
        "INSERT INTO `lifecycles` (`id`, `opened`, `distributed`, `proccesing`, `checking`, `closed`) VALUES (NULL, CURRENT_TIMESTAMP, NULL, NULL, NULL, NULL);",
        (error, cycles) => {
          if (error) res.status(500).json({ error, message: error.sqlMessage });
          else if (cycles) {
            cycles.insertId > 0
              ? connection.query(
                  `INSERT INTO requests (name, description, comment, priority, activId, file, categoryId, userId, lifecycleId)  
                  VALUES ("${req.body.name}","${req.body.description}","${req.body.comment}","${req.body.priority}","${req.body.activId}",
                  "${req.body.file}", "${req.body.categoryId}", "${req.body.userId}", "${cycles.insertId}")`,
                  (isError, created) => {
                    if (isError) {
                      connection.query(
                        `DELETE FROM lifecycles WHERE id = ${cycles.insertId}`
                      );
                      res
                        .status(500)
                        .json({ isError, message: isError.sqlMessage });
                    } else if (created)
                      res
                        .status(200)
                        .json({ created, message: "Заявка успешно создана!" });
                  }
                )
              : res.status(500).json({
                  cycles,
                  message: "Не удалось создать жизненный цикл!",
                });
          }
        }
      );
      connection.release();
    } else if (err) {
      res.status(500).json({ err, message: err.message });
    }
  });
});

app.get("/api/tickets", (req, res) => {
  pool.getConnection((err, connection) => {
    if (connection) {
      connection.query(
        `SELECT requests.name, requests.description, requests.xecutorId AS "artist", requests.priority, requests.status, requests.comment, requests.id, lifecycles.opened, lifecycles.distributed, 
        lifecycles.proccesing, lifecycles.checking, lifecycles.closed, users.name AS "fio" FROM requests 
        JOIN lifecycles ON requests.lifecycleId = lifecycles.id
        JOIN users ON requests.userId = users.id ORDER BY requests.id DESC `,
        (error, result) => {
          if (result) {
            result.length > 0
              ? res
                  .status(200)
                  .json({ result, message: "Заявки успешно получены!" })
              : res.status(400).json({ result, message: "Заявок нет!" });
          } else if (error)
            res.status(500).json({ error, message: error.sqlMessage });
        }
      );
      connection.release();
    } else if (err) {
      res.status(500).json({ err, message: err.message });
    }
  });
});

app.get("/api/tickets/user", (req, res) => {
  pool.getConnection((err, connection) => {
    if (connection) {
      connection.query(
        `SELECT requests.name,requests.description, requests.priority, requests.status, users.name AS "fio", requests.id, 
        lifecycles.opened, lifecycles.distributed, 
        lifecycles.proccesing, lifecycles.checking, lifecycles.closed FROM requests 
        LEFT JOIN users ON users.id = requests.xecutorId
        JOIN lifecycles ON requests.lifecycleId = lifecycles.id
        WHERE requests.userId = ${req.query.userId} ORDER BY requests.id DESC`,
        (error, result) => {
          if (error) res.status(500).json({ error, message: error.sqlMessage });
          else if (result)
            result.length > 0
              ? res
                  .status(200)
                  .json({ result, message: "Тикеты пользователя получены!" })
              : res.status(400).json({ result, message: "Тикетов нет!" });
        }
      );
      connection.release();
    } else if (err) {
      res.status(500).json({ err, message: err.message });
    }
  });
});

app.get("/api/tickets/artists", (req, res) => {
  pool.getConnection((err, connection) => {
    if (connection) {
      connection.query(
        `SELECT users.id, users.name FROM users JOIN roles ON users.roleId = roles.id WHERE roles.id = 2`,
        (error, result) => {
          if (error) res.status(500).json({ error, message: error.sqlMessage });
          else if (result) {
            result.length > 0
              ? res
                  .status(200)
                  .json({ result, message: "Исполнители найдены!" })
              : res
                  .status(400)
                  .json({ result, message: "Исполнители не найдены" });
          }
        }
      );
      connection.release();
    } else if (err) res.status(500).json({ err, message: err.message });
  });
});

app.post("/api/tickets/artist/appoint", (req, res) => {
  console.log(req.body);
  pool.getConnection((err, connection) => {
    if (connection) {
      connection.query(
        `UPDATE requests SET xecutorId= "${req.body.xecutorId}" WHERE id =${req.body.id} `,
        (error, result) => {
          if (error) res.status(500).json({ error, message: error.sqlMessage });
          else if (result) {
            console.log(result);
            result.affectedRows > 0
              ? res
                  .status(200)
                  .json({ result, message: "Успешно назначен исполнитель!" })
              : res
                  .status(400)
                  .json({
                    result,
                    message: "Не удалось назначить исполнителя!",
                  });
          }
        }
      );
    } else if (err) res.status(500).json({ err, message: err.message });
  });
});

app.use((req, res) => {
  sendHTML(req.url, res);
});

app.listen(port, () => {
  console.log(`Example app listening on port http://localhost:${port}`);
});
