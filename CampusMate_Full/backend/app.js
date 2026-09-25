const express=require('express');const cors=require('cors');const mongoose=require('mongoose');require('dotenv').config();
const app=express();app.use(cors({origin:true}));app.use(express.json({limit:'2mb'}));app.get('/',(_,res)=>res.json({success:true,message:'CampusMate API running',version:'2.0.0'}));app.get('/api/health',(_,res)=>res.json({success:true,message:'API healthy'}));
let promise=null;async function connectDB(){if(mongoose.connection.readyState===1)return;if(!process.env.MONGODB_URI)throw Error('MONGODB_URI missing');if(!promise)promise=mongoose.connect(process.env.MONGODB_URI,{serverSelectionTimeoutMS:10000});await promise}
const gate=async(req,res,next)=>{try{await connectDB();next()}catch(e){console.error(e);res.status(500).json({success:false,message:'Database connection failed'})}};
app.use('/api',gate);
app.use('/api/auth',require('./routes/auth'));app.use('/api/users',require('./routes/users'));app.use('/api/communities',require('./routes/communities'));app.use('/api/posts',require('./routes/posts'));app.use('/api/chats',require('./routes/chats'));app.use('/api/admin',require('./routes/admin'));app.use('/api/config',require('./routes/config'));app.use('/api/upload',require('./routes/upload'));
module.exports={app,connectDB};
