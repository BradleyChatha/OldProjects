/*    */ package sealab.mods.stackpack.code;
/*    */ 
/*    */ import abv;
/*    */ import aqw;
/*    */ import nm;
/*    */ import oe;
/*    */ import ue;
/*    */ import yb;
/*    */ import yc;
/*    */ import yd;
/*    */ import zk;
/*    */ 
/*    */ 
/*    */ public class Stacker
/*    */   extends zk
/*    */ {
/*    */   public Stacker(int id, yc toolMaterial) {
/* 18 */     super(id, toolMaterial);
/* 19 */     this.cw = 1;
/* 20 */     a(Base.tabStackPack);
/*    */   }
/*    */ 
/*    */   
/*    */   public yd a(yd par1ItemStack, abv par2World, ue par3EntityPlayer) {
/* 25 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.ca, Base.eblockStackItem);
/* 26 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.R, Base.glassStackItem);
/* 27 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.B, Base.cobbleStackItem);
/* 28 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.A, Base.dirtStackItem);
/* 29 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.M, Base.ioreStackItem);
/* 30 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.T, Base.lapisStackItem);
/* 31 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.J, Base.sandStackItem);
/* 32 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.y, Base.stoneStackItem);
/* 33 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.an, Base.iblockStackItem);
/* 34 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.K, Base.gravelStackItem);
/* 35 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.L, Base.goreStackItem);
/* 36 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.am, Base.gblockStackItem);
/* 37 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.bi, Base.glowstoneStack);
/* 38 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.bh, Base.soulSand);
/* 39 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.bg, Base.netherRack);
/* 40 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.O, Base.woodStack);
/* 41 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.at, Base.mossCobStack);
/* 42 */     StackMethod.Stacker(par1ItemStack, par2World, par3EntityPlayer, aqw.aC, Base.dblockStack);
/*    */     
/* 44 */     StackMethod.StackerItem(par1ItemStack, par2World, par3EntityPlayer, yb.bo, Base.rFlesh);
/* 45 */     StackMethod.StackerItem(par1ItemStack, par2World, par3EntityPlayer, yb.o, Base.coalStack);
/* 46 */     StackMethod.StackerItem(par1ItemStack, par2World, par3EntityPlayer, yb.q, Base.iIngot);
/* 47 */     StackMethod.StackerItem(par1ItemStack, par2World, par3EntityPlayer, yb.r, Base.gIngot);
/* 48 */     StackMethod.StackerItem(par1ItemStack, par2World, par3EntityPlayer, yb.aE, Base.redstoneStack);
/* 49 */     StackMethod.StackerItem(par1ItemStack, par2World, par3EntityPlayer, yb.aV, Base.glowstoneDustStack);
/* 50 */     StackMethod.StackerItem(par1ItemStack, par2World, par3EntityPlayer, yb.cb, Base.quartzStack);
/* 51 */     StackMethod.StackerItem(par1ItemStack, par2World, par3EntityPlayer, yb.p, Base.diamondStack);
/* 52 */     StackMethod.StackerItem(par1ItemStack, par2World, par3EntityPlayer, yb.M, Base.stringStack);
/* 53 */     StackMethod.StackerItem(par1ItemStack, par2World, par3EntityPlayer, yb.n, Base.arrowStack);
/* 54 */     StackMethod.StackerItem(par1ItemStack, par2World, par3EntityPlayer, yb.F, Base.stickStack);
/*    */     
/* 56 */     par1ItemStack.a(1, (oe)par3EntityPlayer);
/* 57 */     return par1ItemStack;
/*    */   }
/*    */ 
/*    */ 
/*    */   
/*    */   public boolean onLeftClickEntity(yd stack, ue player, nm entity) {
/* 63 */     if (entity instanceof of) {
/* 64 */       stack.a(-1, (oe)player);
/*    */     }
/* 66 */     return false;
/*    */   }
/*    */ }


/* Location:              C:\Users\Sealab\Desktop\Preservation\StackPack\compiled\!\sealab\mods\stackpack\code\Stacker.class
 * Java compiler version: 6 (50.0)
 * JD-Core Version:       1.1.3
 */