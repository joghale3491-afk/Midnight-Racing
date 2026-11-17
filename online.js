/*
  MIDNIGHT RUN account + cloud-save + realtime room starter.
  Configure SUPABASE_URL and SUPABASE_ANON_KEY below after creating a Supabase project.
  Never put a service_role key in this client file.
*/
const SUPABASE_URL = "https://YOUR_PROJECT.supabase.co";
const SUPABASE_ANON_KEY = "YOUR_SUPABASE_ANON_KEY";
let mrSupabase = null, mrUser = null, mrChannel = null;
const mrStatus = (s) => { const el=document.getElementById("mrStatus"); if(el) el.textContent=s; };
async function mrInit(){
  if(!window.supabase?.createClient || SUPABASE_URL.includes("YOUR_PROJECT")) { mrStatus("Offline profile mode — connect Supabase to enable accounts and online rooms."); return; }
  mrSupabase=window.supabase.createClient(SUPABASE_URL,SUPABASE_ANON_KEY);
  const {data:{session}}=await mrSupabase.auth.getSession(); mrUser=session?.user||null;
  mrStatus(mrUser?`Signed in: ${mrUser.email}`:"Not signed in");
  mrSupabase.auth.onAuthStateChange((_e,session)=>{mrUser=session?.user||null;mrStatus(mrUser?`Signed in: ${mrUser.email}`:"Not signed in");});
}
async function mrSignUp(email,password){
 if(!mrSupabase) throw Error("Cloud service is not configured yet.");
 if(password.length<10) throw Error("Use a password with at least 10 characters.");
 const {error}=await mrSupabase.auth.signUp({email,password}); if(error)throw error; mrStatus("Check your email to verify your account.");
}
async function mrSignIn(email,password){
 if(!mrSupabase) throw Error("Cloud service is not configured yet.");
 const {error}=await mrSupabase.auth.signInWithPassword({email,password}); if(error)throw error;
}
async function mrSignOut(){if(mrSupabase) await mrSupabase.auth.signOut();}
function mrSnapshot(){
 // Snapshot app-owned browser storage for portability. Do not store credentials or tokens.
 const data={};
 for(let i=0;i<localStorage.length;i++){const k=localStorage.key(i);if(!/supabase|auth-token|password|secret/i.test(k))data[k]=localStorage.getItem(k);}
 return {version:1,updated_at:new Date().toISOString(),storage:data};
}
async function mrSaveCloud(){
 if(!mrSupabase||!mrUser) throw Error("Sign in to save to the cloud.");
 const payload=mrSnapshot();
 const {error}=await mrSupabase.from("player_saves").upsert({user_id:mrUser.id,save_data:payload,updated_at:new Date().toISOString()},{onConflict:"user_id"});
 if(error)throw error; mrStatus("Cloud save complete.");
}
async function mrLoadCloud(){
 if(!mrSupabase||!mrUser) throw Error("Sign in to load your cloud save.");
 const {data,error}=await mrSupabase.from("player_saves").select("save_data").eq("user_id",mrUser.id).maybeSingle();
 if(error)throw error;if(!data?.save_data?.storage)throw Error("No cloud save found yet.");
 Object.entries(data.save_data.storage).forEach(([k,v])=>localStorage.setItem(k,v));
 mrStatus("Cloud save loaded. Reload the game to apply it.");
}
async function mrCreateRoom(roomCode){
 if(!mrSupabase||!mrUser) throw Error("Sign in to use online multiplayer.");
 mrChannel=mrSupabase.channel("race:"+roomCode,{config:{presence:{key:mrUser.id},broadcast:{self:false}}});
 await mrChannel.subscribe(async status=>{if(status==="SUBSCRIBED"){await mrChannel.track({user_id:mrUser.id,joined_at:new Date().toISOString()});mrStatus("Online room connected: "+roomCode);}});
 return mrChannel;
}
async function mrSendRaceState(state){
 if(!mrChannel) return;
 await mrChannel.send({type:"broadcast",event:"race-state",payload:{user_id:mrUser?.id,state}});
}
async function mrLeaveRoom(){if(mrChannel){await mrSupabase.removeChannel(mrChannel);mrChannel=null;}}
window.MidnightRunOnline={init:mrInit,signUp:mrSignUp,signIn:mrSignIn,signOut:mrSignOut,save:mrSaveCloud,load:mrLoadCloud,createRoom:mrCreateRoom,sendRaceState:mrSendRaceState,leaveRoom:mrLeaveRoom};
