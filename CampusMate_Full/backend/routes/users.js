const router=require('express').Router(); const bcrypt=require('bcryptjs'); const User=require('../models/User'); const auth=require('../middleware/auth');
router.get('/me',auth,async(req,res)=>res.json({success:true,user:{id:req.user._id,name:req.user.name,email:req.user.email,role:req.user.role,profilePic:req.user.profilePic,bio:req.user.bio}}));
router.get('/search',auth,async(req,res)=>{const q=String(req.query.q||'').trim(); const users=await User.find({active:true,$or:[{name:new RegExp(q,'i')},{email:new RegExp(q,'i')}]}).select('_id name email profilePic bio').limit(30);res.json({success:true,users})});
router.patch('/me',auth,async(req,res)=>{const u=await User.findByIdAndUpdate(req.user._id,{name:req.body.name,bio:req.body.bio,profilePic:req.body.profilePic},{new:true});res.json({success:true,user:{id:u._id,name:u.name,email:u.email,role:u.role,profilePic:u.profilePic,bio:u.bio}})});
module.exports=router;
