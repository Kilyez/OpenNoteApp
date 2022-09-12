const express = require("express");
const Notes = require("../models/note.models");
const Course = require("../models/course.model");
var path = require("path");
const fs = require("fs");
const router = express.Router();
const multer = require("multer");
const { ifError } = require("assert");
const storage = multer.diskStorage({
  filename: (req, file, cb) => {
    const id = req.body.id;
    console.log(req.body);
    const title = req.body.title;
    const course = req.body.course;
    const author = req.body.user;
    const timeStamp = Date.now();
    const pathName =
      "notes/" + req.body.user + "/" + timeStamp + file.originalname;
    cb(null, timeStamp + file.originalname);
    Notes.create({ title, course, pathName, timeStamp, creator: id, author });
  },
  destination: (req, file, cb) => {
    cb(null, "notes/" + req.body.user);
  },
});
const upload = multer({ storage: storage });

router.post("/upload", upload.single("file"), async (req, res) => {
  res.status(200).json();
});

router.get("/getFilesPath", async (req, res) => {
  Notes.find(
    { creator: req.query.user_id },
    null,
    { limit: req.query.limit, skip: req.query.limit * (req.query.page - 1) },
    (err, notes) => {
      if (err) {
        res.status(500).json({ error: err });
      } else {
        return res.status(200).json(notes.map((n) => n.pathName));
      }
    }
  );
});

router.get("/getFilesPathSorted", async (req, res) => {
  if (req.query.course_id == "") {
    Notes.find(
      {},
      null,
      {
        sort: { like: -1 },
        limit: req.query.limit,
        skip: req.query.limit * (req.query.page - 1),
      },
      (err, notes) => {
        if (err) {
          res.status(500).json({ error: err });
        } else {
          return res.status(200).json(notes.map((n) => n.pathName));
        }
      }
    );
  } else {
    console.log(req.query.course_id);
    Notes.find(
      { course: req.query.course_id },
      null,
      {
        sort: { like: -1 },
        limit: req.query.limit,
        skip: req.query.limit * (req.query.page - 1),
      },
      (err, notes) => {
        if (err) {
          res.status(500).json({ error: err });
        } else {
          console.log(notes);
          return res.status(200).json(notes.map((n) => n.pathName));
        }
      }
    );
  }
});

router.post("/updateNote", async (req, res) => {
  // console.log(req.body)
  if (req.body.isLiked) {
    Notes.findOneAndUpdate(
      { _id: req.body._id },
      { $addToSet: { like: req.body.userId } },
      function (err, note) {
        if (err) return res.status(500).json({ error: err });
        res.status(200).json({ success: true });
      }
    );
  } else {
    Notes.findOneAndUpdate(
      { _id: req.body._id },
      { $pull: { like: req.body.userId } },
      function (err, note) {
        if (err) return res.status(500).json({ error: err });
        res.status(200).json({ success: true });
      }
    );
  }
});

router.get("/getNote", async (req, res) => {
  Notes.findOne({ pathName: req.query.path }, (err, note) => {
    if (err) {
      res.status(500).json({ error: err });
    } else {
      Course.findOne({ _id: note.course }, (err, course) => {
        if (err) {
          res.status(500).json({ error: err });
        } else {
          return res
            .status(200)
            .json({
              course: course.course,
              title: note.title,
              author: note.author,
              _id: note._id,
              like: note.like,
            });
        }
      });
    }
  });
});

router.get("/getFile", async (req, res) => {
  res.contentType("application/pdf");
  var stream = fs.createReadStream(req.query.path);
  stream.pipe(res);
});

router.get("/deleteNote", async (req, res) => {
  Notes.deleteOne({ _id: req.query._id }, function (err, note) {
    if (err) {
      return res.status(500).json({ error: err });
    } else {
      return res.status(200).json({ success: true });
    }
  });
});

module.exports = router;
