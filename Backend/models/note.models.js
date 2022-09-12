const mongoose = require('mongoose');
const Schema = mongoose.Schema;

const noteSchema = new Schema({
    title:{
        type:String,
    },
    course:{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Course' 
    },
    pathName:{
        type:String
    },
    timeStamp:{
        type:String
    },
    creator: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User' 
    },
    like: [{
        
        type: mongoose.Schema.Types.ObjectId,
        ref: 'User' 
        
    }],
    author:{
        
        type:String
    },
})

module.exports = mongoose.model('Notes',noteSchema)