const express = require("express");
const Course = require("../models/course.model");
const router = express.Router();

var array = [
  { course: "Calcolabilità e Complessità" },
  { course: "Economia e Gestione dell’innovazione" },
  { course: "Interazione Uomo Macchina e Tecnologie Web" },
  { course: "Tecnologie Web" },
  { course: "Linguaggi e Paradigmi di Programmazione" },
  { course: "Metodi Formali dell’informatica " },
  { course: "Programmazione 3" },
  { course: "Reti" },
  { course: "Sicurezza" },
  { course: "Sistemi Informativi" },
  { course: "Sistemi Intelligenti" },
  { course: "Storia dell’informatica" },
  { course: "Sviluppo delle Applicazioni Software" },
];
// (async() => {await Course.create(array);})()
router.get('/getCourse', async(req, res) => {
    Course.find({}).then(courses => {
        res.status(200).json(courses);
    })
})

module.exports = router;
