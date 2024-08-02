local e={initialized=false,shared_data={}}local t={}local a=table.concat local
o={{2,3,4,5,6},{4,1,6,3,5},{1,4,5,2,6},{2,6,3,5,1},{3,6,1,4,2},{4,5,2,3,1}}local
i={}local n={}local s={}local h={}local function r(d,l,u,c,m,f)return
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
n[rt]=ct s[rt]=mt i[rt]=string.char(dt)end end end function
e.make_canvas_scanline(ft)return
setmetatable({},{__newindex=function(wt,yt,pt)if type(yt)=="number"and yt%1~=0
then error(("Tried to write a float pixel. x:%s y:%s"):format(yt,ft),2)else
rawset(wt,yt,pt)end end})end function e.make_canvas(vt)local
bt=e.make_canvas_scanline("NONE")local gt=getmetatable(bt)function
gt.tostring()return"pixelbox_dummy_oob"end return setmetatable(vt
or{},{__index=function(kt,qt)if type(qt)=="number"and qt%1~=0 then
error(("Tried to write float scanline. y:%s"):format(qt),2)end return bt
end})end function e.setup_canvas(jt,xt,zt)for Et=1,jt.height do if not
rawget(xt,Et)then rawset(xt,Et,e.make_canvas_scanline(Et))end for Tt=1,jt.width
do xt[Et][Tt]=zt end end return xt end function e.restore(At,Ot,It)if not It
then local Nt=e.setup_canvas(At,e.make_canvas(),Ot)At.canvas=Nt At.CANVAS=Nt
else e.setup_canvas(At,At.canvas,Ot)end end local St={}local
Ht={0,0,0,0,0,0}function t:render()local Rt=self.term local
Dt,Lt=Rt.blit,Rt.setCursorPos local Ut=self.canvas local Ct,Mt,Ft={},{},{}local
Wt,Yt=self.width,self.height local Pt=0 for Vt=1,Yt,3 do Pt=Pt+1 local
Bt=Ut[Vt]local Gt=Ut[Vt+1]local Kt=Ut[Vt+2]local Qt=0 for Jt=1,Wt,2 do local
Xt=Jt+1 local Zt,ea,ta,aa,oa,ia=Bt[Jt],Bt[Xt],Gt[Jt],Gt[Xt],Kt[Jt],Kt[Xt]local
na,sa,ha=" ",1,Zt local ra=ea==Zt and ta==Zt and aa==Zt and oa==Zt and ia==Zt
if not ra then St[ia]=5 St[oa]=4 St[aa]=3 St[ta]=2 St[ea]=1 St[Zt]=0 local
da=St[ea]+St[ta]*3+St[aa]*4+St[oa]*20+St[ia]*100 local la=n[da]local
ua=s[da]Ht[1]=Zt Ht[2]=ea Ht[3]=ta Ht[4]=aa Ht[5]=oa Ht[6]=ia
sa=Ht[la]ha=Ht[ua]na=i[da]end Qt=Qt+1 Ct[Qt]=na Mt[Qt]=h[sa]Ft[Qt]=h[ha]end
Lt(1,Pt)Dt(a(Ct,""),a(Mt,""),a(Ft,""))end end function
t:clear(ca)e.restore(self,h[ca or""]and ca or self.background,true)end function
t:set_pixel(ma,fa,wa)self.canvas[fa][ma]=wa end function
t:set_canvas(ya)self.canvas=ya self.CANVAS=ya end function
t:resize(pa,va,ba)self.term_width=pa self.term_height=va self.width=pa*2
self.height=va*3 e.restore(self,ba or self.background,true)end
function e.module_error(za,Ea,Ta,Aa)Ta=Ta or 1 if za.contact and not Aa then local
Oa,Ia=pcall(error,Ea,Ta+2)printError(Ia)error((za.report_msg
or"\nReport module issue at:\n-> %s"):format(za.contact),0)elseif not Aa then
error(Ea,Ta+1)end end function t:load_module(Na)for Sa,Ha in ipairs(Na or{})do
local Ra,Da=Ha.init(self,Ha,e,e.shared_data,e.initialized)Da=Da or{}local
La={author=Ha.author,name=Ha.name,contact=Ha.contact,report_msg=Ha.report_msg,fn=Ra}if
self.modules[Ha.id]and not Na.force then
e.module_error(La,("Module ID conflict: %q"):format(Ha.id),2,Na.supress)else
self.modules[Ha.id]=La if Da.verified_load then Da.verified_load()end end for
Ua,Ca in pairs(Ra)do if self.modules.module_functions[Ua]and not Na.force then
e.module_error(La,("Module %q tried to register already existing element: %q"):format(Ha.id,Ua),2,Na.supress)else
self.modules.module_functions[Ua]={id=Ha.id,name=Ua}end end end end function
e.new(Ma,Fa,Wa)local Ya={modules={module_functions={}}}Ya.background=Fa or
Ma.getBackgroundColor()local Pa,Va=Ma.getSize()Ya.term=Ma
setmetatable(Ya,{__index=function(Ba,Ga)local
Ka=rawget(Ya.modules.module_functions,Ga)if Ka then return
Ya.modules[Ka.id].fn[Ka.name]end return rawget(t,Ga)end})if
type(Wa)=="table"then Ya:load_module(Wa)end Ya.term_width=Pa Ya.term_height=Va
Ya.width=Pa*2 Ya.height=Va*3 e.restore(Ya,Ya.background)if not e.initialized
then X()e.initialized=true end return Ya end return e