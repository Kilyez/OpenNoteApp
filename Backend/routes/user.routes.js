const express = require('express')
const User = require('../models/user.model')

const router = express.Router()

router.post('/signup', (req,res)=> {
    User.findOne({email:req.body.email},(err,user)=>{
        if(err){
            console.log(err)
            res.status(500).json({'error': err})
        }else{
            if(user==null){
                const user = User({
                    email:req.body.email,
                    password:req.body.password
                })
                user.save().then((user) => {
                    console.log(user)
                    res.status(200).json(user)
                },err => {
                    console.log(err)
                    res.status(500).json({'error': err})
                })
            }else{
                res.status(400).json({
                    'message':'this email is already used'
                })
            }
           
        }
    })
    
})

router.post('/signin', (req,res)=> {
    User.findOne({email:req.body.email},(err,user)=>{
        if(err){
            console.log(err)
            res.status(500).json({'error': err}  )
        }else{
            if(user == null){
                res.status(400).json({
                    "message" : 'mail or password not valid'
                })
            }else{
                user.comparePassword(req.body.password,function(err,isMatch){
                    if (isMatch && !err) {
                        res.status(200).json(user)
                    }else{
                        res.status(400).json({
                            message: 'password not valid'
                        })
                    }
                })
            }
        }
    })
})

module.exports = router