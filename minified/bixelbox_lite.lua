local e={initialized=false,shared_data={},internal={}}local t={}local
a=table.concat local o={}local function i()for n=0,15 do
o[2^n]=("%x"):format(n)end end e.internal.to_blit_lookup=o
e.internal.generate_lookups=i function e.make_canvas_scanline(s)return
setmetatable({},{__newindex=function(h,r,d)if type(r)=="number"and r%1~=0 then
error(("Tried to write a float pixel. x:%s y:%s"):format(r,s),2)else
rawset(h,r,d)end end})end function e.make_canvas(l)local
u=e.make_canvas_scanline("NONE")local c=getmetatable(u)function
c.tostring()return"pixelbox_dummy_oob"end return setmetatable(l
or{},{__index=function(m,f)if type(f)=="number"and f%1~=0 then
error(("Tried to write float scanline. y:%s"):format(f),2)end return u end})end
function e.setup_canvas(w,y,p,v)for b=1,w.height do local g if not
rawget(y,b)then g=e.make_canvas_scanline(b)rawset(y,b,g)else g=y[b]end for
k=1,w.width do if not(g[k]and v)then g[k]=p end end end return y end function
e.restore(q,j,x)if not x then local
z=e.setup_canvas(q,e.make_canvas(),j)q.canvas=z q.CANVAS=z else
e.setup_canvas(q,q.canvas,j,true)end end local E=string.rep function
t:render()local T=self.term local A,O=T.blit,T.setCursorPos local I=self.canvas
local N,S={},{}local H,R={},{}local D,L=self.width,self.height local
U=E("\131",D)local C=E("\143",D)local M=0 for F=1,L,3 do M=M+2 local
W=I[F]local Y=I[F+1]local P=I[F+2]local V=1 for B=1,D do local G=W[B]local
K=Y[B]local Q=P[B]N[V]=o[G]S[V]=o[K]H[V]=o[K or K]R[V]=o[Q or K]V=V+1 end
O(1,M-1)A(C,a(N,""),a(S,""))O(1,M)A(U,a(H,""),a(R,""))end end function
t:clear(J)e.restore(self,o[J or""]and J or self.background,true)end function
t:set_pixel(X,Z,et)self.canvas[Z][X]=et end function
t:set_canvas(tt)self.canvas=tt self.CANVAS=tt end function
t:resize(at,ot,it)self.term_width=at self.term_height=ot self.width=at*2
self.height=ot*3 e.restore(self,it or self.background,true)end function
e.module_error(nt,st,ht,rt)ht=ht or 1 if nt.__contact and not rt then local
dt,lt=pcall(error,st,ht+2)printError(lt)error((nt.__report_msg
or"\nReport module issue at:\n-> __contact"):gsub("[%w_]+",nt),0)elseif not rt
then error(st,ht+1)end end function t:load_module(ut)for ct,mt in ipairs(ut
or{})do local
ft={__author=mt.author,__name=mt.name,__contact=mt.contact,__report_msg=mt.report_msg}local
wt,yt=mt.init(self,ft,e,e.shared_data,e.initialized,ut)yt=yt or{}ft.__fn=wt if
self.modules[mt.id]and not ut.force then
e.module_error(ft,("Module ID conflict: %q"):format(mt.id),2,ut.supress)else
self.modules[mt.id]=ft if yt.verified_load then yt.verified_load()end end for
pt in pairs(wt)do if self.modules.module_functions[pt]and not ut.force then
e.module_error(ft,("Module %q tried to register already existing element: %q"):format(mt.id,pt),2,ut.supress)else
self.modules.module_functions[pt]={id=mt.id,name=pt}end end end end function
e.new(vt,bt,gt)local kt={modules={module_functions={}}}kt.background=bt or
vt.getBackgroundColor()local qt,jt=vt.getSize()kt.term=vt
setmetatable(kt,{__index=function(xt,zt)local
Et=rawget(kt.modules.module_functions,zt)if Et then return
kt.modules[Et.id].__fn[Et.name]end return
rawget(t,zt)end})kt.__bixelbox_lite=true kt.term_width=qt kt.term_height=jt
kt.width=qt kt.height=math.ceil(jt*(3/2))e.restore(kt,kt.background)if
type(gt)=="table"then kt:load_module(gt)end if not e.initialized then
i()e.initialized=true end return kt end return e