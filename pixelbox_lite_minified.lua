local e={initialized=false,shared_data={},internal={}}local t={}local
a=table.concat local
o={{2,3,4,5,6},{4,1,6,3,5},{1,4,5,2,6},{2,6,3,5,1},{3,6,1,4,2},{4,5,2,3,1}}local
i={}local n={}local s={}local h={}e.internal.texel_character_lookup=i
e.internal.texel_foreground_lookup=n e.internal.texel_background_lookup=s
e.internal.to_blit_lookup=h e.internal.sampling_lookup=o local function
r(d,l,u,c,m,f)return l*1+u*3+c*4+m*20+f*100 end local function
w(y,p,v,b,g,k)local q={y,p,v,b,g,k}local j={}for x=1,6 do local z=q[x]local
E=j[z]j[z]=E and E+1 or 1 end local T={}for A,O in pairs(j)do
T[#T+1]={value=A,count=O}end table.sort(T,function(I,N)return I.count>N.count
end)local S={}for H=1,6 do local R=q[H]if R==T[1].value then S[H]=1 elseif
R==T[2].value then S[H]=0 else local D=o[H]for L=1,5 do local U=D[L]local
C=q[U]local M=C==T[1].value local F=C==T[2].value if M or F then S[H]=M and 1
or 0 break end end end end local W=128 local Y=S[6]if S[1]~=Y then W=W+1 end if
S[2]~=Y then W=W+2 end if S[3]~=Y then W=W+4 end if S[4]~=Y then W=W+8 end if
S[5]~=Y then W=W+16 end local P,V if#T>1 then P=T[Y+1].value V=T[2-Y].value
else P=T[1].value V=T[1].value end return W,P,V end local function
B(G,K,Q)return math.floor(G/(K^Q))end local J=0 local function X()for Z=0,15 do
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
end return xt end function e.restore(It,Nt,St)if not St then local
Ht=e.setup_canvas(It,e.make_canvas(),Nt)It.canvas=Ht It.CANVAS=Ht else
e.setup_canvas(It,It.canvas,Nt,true)end end local Rt={}local
Dt={0,0,0,0,0,0}function t:render()local Lt=self.term local
Ut,Ct=Lt.blit,Lt.setCursorPos local Mt=self.canvas local Ft,Wt,Yt={},{},{}local
Pt,Vt=self.width,self.height local Bt=0 for Gt=1,Vt,3 do Bt=Bt+1 local
Kt=Mt[Gt]local Qt=Mt[Gt+1]local Jt=Mt[Gt+2]local Xt=0 for Zt=1,Pt,2 do local
ea=Zt+1 local ta,aa,oa,ia,na,sa=Kt[Zt],Kt[ea],Qt[Zt],Qt[ea],Jt[Zt],Jt[ea]local
ha,ra,da=" ",1,ta local la=aa==ta and oa==ta and ia==ta and na==ta and sa==ta
if not la then Rt[sa]=5 Rt[na]=4 Rt[ia]=3 Rt[oa]=2 Rt[aa]=1 Rt[ta]=0 local
ua=Rt[aa]+Rt[oa]*3+Rt[ia]*4+Rt[na]*20+Rt[sa]*100 local ca=n[ua]local
ma=s[ua]Dt[1]=ta Dt[2]=aa Dt[3]=oa Dt[4]=ia Dt[5]=na Dt[6]=sa
ra=Dt[ca]da=Dt[ma]ha=i[ua]end Xt=Xt+1 Ft[Xt]=ha Wt[Xt]=h[ra]Yt[Xt]=h[da]end
Ct(1,Bt)Ut(a(Ft,""),a(Wt,""),a(Yt,""))end end function
t:clear(fa)e.restore(self,h[fa or""]and fa or self.background,true)end function
t:set_pixel(wa,ya,pa)self.canvas[ya][wa]=pa end function
t:set_canvas(va)self.canvas=va self.CANVAS=va end function
t:resize(ba,ga,ka)self.term_width=ba self.term_height=ga self.width=ba*2
self.height=ga*3 e.restore(self,ka or self.background,true)end function
e.module_error(qa,ja,xa,za)xa=xa or 1 if qa.__contact and not za then local
Ea,Ta=pcall(error,ja,xa+2)printError(Ta)error((qa.__report_msg
or"\nReport module issue at:\n-> __contact"):gsub("[%w_]+",qa),0)elseif not za
then error(ja,xa+1)end end function t:load_module(Aa)for Oa,Ia in ipairs(Aa
or{})do local
Na={__author=Ia.author,__name=Ia.name,__contact=Ia.contact,__report_msg=Ia.report_msg}local
Sa,Ha=Ia.init(self,Na,e,e.shared_data,e.initialized,Aa)Ha=Ha or{}Na.__fn=Sa if
self.modules[Ia.id]and not Aa.force then
e.module_error(Na,("Module ID conflict: %q"):format(Ia.id),2,Aa.supress)else
self.modules[Ia.id]=Na if Ha.verified_load then Ha.verified_load()end end for
Ra,Da in pairs(Sa)do if self.modules.module_functions[Ra]and not Aa.force then
e.module_error(Na,("Module %q tried to register already existing element: %q"):format(Ia.id,Ra),2,Aa.supress)else
self.modules.module_functions[Ra]={id=Ia.id,name=Ra}end end end end function
e.new(La,Ua,Ca)local Ma={modules={module_functions={}}}Ma.background=Ua or
La.getBackgroundColor()local Fa,Wa=La.getSize()Ma.term=La
setmetatable(Ma,{__index=function(Ya,Pa)local
Va=rawget(Ma.modules.module_functions,Pa)if Va then return
Ma.modules[Va.id].__fn[Va.name]end return rawget(t,Pa)end})Ma.term_width=Fa
Ma.term_height=Wa Ma.width=Fa*2 Ma.height=Wa*3 e.restore(Ma,Ma.background)if
type(Ca)=="table"then Ma:load_module(Ca)end if not e.initialized then
X()e.initialized=true end return Ma end return
e