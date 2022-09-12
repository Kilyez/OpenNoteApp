const express = require('express')
const User = require('../models/user.model')
const jwt = require("jsonwebtoken")
const auth = require('../middlewares/auth')
const router = express.Router()
const fs = require('fs')

router.post('/signup', (req,res)=> {
    User.findOne({email:req.body.email},(err,user)=>{
        if(err){
            console.log(err)
            res.status(500).json({error: err})
        }else{
            if(user==null){
                const user = User({
                    email:req.body.email,
                    password:req.body.password
                })
                user.save().then((user) => {
                    fs.mkdirSync('./notes/'+req.body.email)
                    console.log(user)
                    const token = jwt.sign({id: user.id},"passwordKey")
                        res.status(200).json({token: token,... user._doc})
                },err => {
                    console.log(err)
                    res.status(500).json({error: err})
                })
            }else{
                res.status(400).json({
                    message :'this email is already used'
                })
            }
           
        }
    })
    
})

router.post('/signin', (req,res)=> {
    User.findOne({email:req.body.email},(err,user)=>{
        if(err){
            console.log(err)
            res.status(500).json({error: err}  )
        }else{
            if(user == null){
                res.status(400).json({
                    message : 'mail or password not valid'
                })
            }else{
                user.comparePassword(req.body.password,function(err,isMatch){
                    if (isMatch && !err) {
                        const token = jwt.sign({id: user.id},"passwordKey")
                        res.status(200).json({token: token,... user._doc})
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

router.post('/tokenIsValid', async (req, res) => {
    try{
        const token = req.header('token')
        if(!token) return res.json(false)
        const verified = jwt.verify(token,'passwordKey')
        if (!verified) return res.json(false)

        const user = await User.findById(verified.id)
        if(!user) return res.json(false)
        res.json(true)

    }catch(e){
        res.status(500).json({error: e.message})
    }    
});

// get user data
router.get('/', auth, async (req,res) => {
    const user = await User.findById(req.user)
    res.json({...user._doc, token: req.token})


});

module.exports = router