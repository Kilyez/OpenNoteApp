const express = require('express')

const app = express()
const port = 8080 || process.env.PORT
const cors = require('cors')
const bodyParser = require('body-parser')

const mongoose = require('mongoose')
const { application } = require('express')

mongoose.connect("mongodb://localhost:27017/mydb")


app.use(cors())
app.use(express.static('public'))
app.use(bodyParser.urlencoded({extended:true}))
app.use(bodyParser.json())
app.use('/',require('./routes/user.routes'))
app.use('/',require('./routes/course.routes'))
app.use('/', require('./routes/notes.routes'))
app.listen(port, () => {
    console.log('port running on ' + port)
})