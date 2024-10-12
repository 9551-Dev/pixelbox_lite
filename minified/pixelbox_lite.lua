local e={initialized=false,shared_data={},internal={}}local t={}local
a=table.concat local
o={{2,3,4,5,6},{4,1,6,3,5},{1,4,5,2,6},{2,6,3,5,1},{3,6,1,4,2},{4,5,2,3,1}}local
i=load("return {"..string.rep("false,",599).."[0]=false}","=pb_preload","t")()local
n=load("return {"..string.rep("false,",599).."[0]=false}","=pb_preload","t")()local
s=load("return {"..string.rep("false,",599).."[0]=false}","=pb_preload","t")()local
h={}e.internal.texel_character_lookup=i e.internal.texel_foreground_lookup=n
e.internal.texel_background_lookup=s e.internal.to_blit_lookup=h
e.internal.sampling_lookup=o local function r(d,l,u,c,m,f)return
l*1+u*3+c*4+m*20+f*100 end local function w(y,p,v,b,g,k)local
q={y,p,v,b,g,k}local j={}for x=1,6 do local z=q[x]local E=j[z]j[z]=E and E+1 or
1 end local T={}for A,O in pairs(j)do T[#T+1]={value=A,count=O}end
table.sort(T,function(I,N)return I.count>N.count end)local S={}for H=1,6 do
local R=q[H]if R==T[1].value then S[H]=1 elseif R==T[2].value then S[H]=0 else
local D=o[H]for L=1,5 do local U=D[L]local C=q[U]local M=C==T[1].value local
F=C==T[2].value if M or F then S[H]=M and 1 or 0 break end end end end local
W=128 local Y=S[6]if S[1]~=Y then W=W+1 end if S[2]~=Y then W=W+2 end if
S[3]~=Y then W=W+4 end if S[4]~=Y then W=W+8 end if S[5]~=Y then W=W+16 end
local P,V if#T>1 then P=T[Y+1].value V=T[2-Y].value else P=T[1].value
V=T[1].value end return W,P,V end local function B(G,K,Q)return
math.floor(G/(K^Q))end local J=0 local function X()for Z=0,15 do
h[2^Z]=("%x"):format(Z)end for et=0,6^6 do local tt=B(et,6,0)%6 local
at=B(et,6,1)%6 local ot=B(et,6,2)%6 local it=B(et,6,3)%6 local nt=B(et,6,4)%6
local st=B(et,6,5)%6 local ht={}ht[st]=5 ht[nt]=4 ht[it]=3 ht[ot]=2 ht[at]=1
ht[tt]=0 local rt=r(ht[tt],ht[at],ht[ot],ht[it],ht[nt],ht[st])if not i[rt]then
J=J+1 local dt,lt,ut=w(tt,at,ot,it,nt,st)local ct=ht[lt]+1 local mt=ht[ut]+1
n[rt]=ct s[rt]=mt i[rt]=string.char(dt)end end end
e.internal.generate_lookups=X e.internal.calculate_texel=w
e.internal.make_pattern_id=r e.internal.base_n_rshift=B function
e.make_canvas_scanline(ft)return
setmetatable({},{__newindex=function(wt,yt,pt)if type(yt)=="number"and yt%1~=0
then error(("Tried to write a float pixel. x:%s y:%s"):format(yt,ft),2)else
rawset(wt,yt,pt)end end})end function e.make_canvas(vt)local
bt=e.make_canvas_scanline("NONE")local gt=getmetatable(bt)function
gt.tostring()return"pixelbox_dummy_oob"end return setmetatable(vt
or{},{__index=function(kt,qt)if type(qt)=="number"and qt%1~=0 then
error(("Tried to write float scanline. y:%s"):format(qt),2)end return bt
end})end function e.setup_canvas(jt,xt,zt,Et)for Tt=1,jt.height do local At if
not rawget(xt,Tt)then At=e.make_canvas_scanline(Tt)rawset(xt,Tt,At)else
At=xt[Tt]end for Ot=1,jt.width do if not(At[Ot]and Et)then At[Ot]=zt end end
end return xt end function e.restore(It,Nt,St,Ht)if not St then local
Rt=e.setup_canvas(It,e.make_canvas(),Nt)It.canvas=Rt It.CANVAS=Rt else
e.setup_canvas(It,It.canvas,Nt,Ht)end end local Dt={}local
Lt={0,0,0,0,0,0}function t:render()local Ut=self.term local
Ct,Mt=Ut.blit,Ut.setCursorPos local Ft=self.canvas local Wt,Yt,Pt={},{},{}local
Vt,Bt=self.x_offset,self.y_offset local Gt,Kt=self.width,self.height local Qt=0
for Jt=1,Kt,3 do Qt=Qt+1 local Xt=Ft[Jt]local Zt=Ft[Jt+1]local ea=Ft[Jt+2]local
ta=0 for aa=1,Gt,2 do local oa=aa+1 local
ia,na,sa,ha,ra,da=Xt[aa],Xt[oa],Zt[aa],Zt[oa],ea[aa],ea[oa]local
la,ua,ca=" ",1,ia local ma=na==ia and sa==ia and ha==ia and ra==ia and da==ia
if not ma then Dt[da]=5 Dt[ra]=4 Dt[ha]=3 Dt[sa]=2 Dt[na]=1 Dt[ia]=0 local
fa=Dt[na]+Dt[sa]*3+Dt[ha]*4+Dt[ra]*20+Dt[da]*100 local wa=n[fa]local
ya=s[fa]Lt[1]=ia Lt[2]=na Lt[3]=sa Lt[4]=ha Lt[5]=ra Lt[6]=da
ua=Lt[wa]ca=Lt[ya]la=i[fa]end ta=ta+1 Wt[ta]=la Yt[ta]=h[ua]Pt[ta]=h[ca]end
Mt(1+Vt,Qt+Bt)Ct(a(Wt,""),a(Yt,""),a(Pt,""))end end function
t:clear(pa)e.restore(self,h[pa or""]and pa or self.background,true,false)end
function t:set_pixel(va,ba,ga)self.canvas[ba][va]=ga end function
t:set_canvas(ka)self.canvas=ka self.CANVAS=ka end function
t:resize(qa,ja,xa)self.term_width=math.floor(qa+0.5)self.term_height=math.floor(ja+0.5)self.width=math.floor(qa+0.5)*2
self.height=math.floor(ja+0.5)*3 e.restore(self,xa or
self.background,true,true)end function e.module_error(za,Ea,Ta,Aa)Ta=Ta or 1 if
za.__contact and not Aa then local
Oa,Ia=pcall(error,Ea,Ta+2)printError(Ia)error((za.__report_msg
or"\nReport module issue at:\n-> __contact"):gsub("[%w_]+",za),0)elseif not Aa
then error(Ea,Ta+1)end end function t:load_module(Na)for Sa,Ha in ipairs(Na
or{})do local
Ra={__author=Ha.author,__name=Ha.name,__contact=Ha.contact,__report_msg=Ha.report_msg}local
Da,La=Ha.init(self,Ra,e,e.shared_data,e.initialized,Na)La=La or{}Ra.__fn=Da if
self.modules[Ha.id]and not Na.force then
e.module_error(Ra,("Module ID conflict: %q"):format(Ha.id),2,Na.supress)else
self.modules[Ha.id]=Ra if La.verified_load then La.verified_load()end end for
Ua in pairs(Da)do if self.modules.module_functions[Ua]and not Na.force then
e.module_error(Ra,("Module %q tried to register already existing element: %q"):format(Ha.id,Ua),2,Na.supress)else
self.modules.module_functions[Ua]={id=Ha.id,name=Ua}end end end end function
e.new(Ca,Ma,Fa)local Wa={modules={module_functions={}}}Wa.background=Ma or
Ca.getBackgroundColor()local Ya,Pa=Ca.getSize()Wa.term=Ca
setmetatable(Wa,{__index=function(Va,Ba)local
Ga=rawget(Wa.modules.module_functions,Ba)if Ga then return
Wa.modules[Ga.id].__fn[Ga.name]end return
rawget(t,Ba)end})Wa.__pixelbox_lite=true Wa.term_width=Ya Wa.term_height=Pa
Wa.width=Ya*2 Wa.height=Pa*3 Wa.x_offset=0 Wa.y_offset=0
e.restore(Wa,Wa.background)if type(Fa)=="table"then Wa:load_module(Fa)end if
not e.initialized then X()e.initialized=true end return Wa end return e