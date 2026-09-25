const express=require('express'); const cors=require('cors'); const mongoose=require('mongoose'); require('dotenv').config();
const auth=require('./routes/auth'); const users=require('./routes/users'); const communities=require('./routes/communities'); const posts=require('./routes/posts'); const chats=require('./routes/chats'); const admin=require('./routes/admin'); const upload=require('./routes/upload'); const config=require('./routes/config');
const app=express(); app.use(cors({origin:true})); app.use(express.json({limit:'1mb'}));
app.get('/',(_,res)=>res.json({success:true,message:'CampusMate API running'}));
app.get('/api/health',(_,res)=>res.json({success:true,message:'API healthy'}));
function mongoUri(){if(process.env.MONGODB_URI)return process.env.MONGODB_URI; throw Error('MONGODB_URI missing');}
let promise=null; async function connectDB(){if(mongoose.connection.readyState===1)return; if(!promise)promise=mongoose.connect(mongoUri(),{serverSelectionTimeoutMS:10000}); await promise;}
app.use('/api',async(req,res,next)=>{try{await connectDB();next()}catch(e){console.error(e);res.status(500).json({success:false,message:'Database connection failed'})}});
app.use('/api/auth',auth); app.use('/api/users',users); app.use('/api/communities',communities); app.use('/api/posts',posts); app.use('/api/chats',chats); app.use('/api/admin',admin); app.use('/api/upload',upload); app.use('/api/config',config);
module.exports={app,connectDB};
