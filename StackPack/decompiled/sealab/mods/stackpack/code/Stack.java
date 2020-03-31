/*    */ package sealab.mods.stackpack.code;
/*    */ 
/*    */ import abv;
/*    */ import cpw.mods.fml.relauncher.Side;
/*    */ import cpw.mods.fml.relauncher.SideOnly;
/*    */ import ue;
/*    */ import yc;
/*    */ import yd;
/*    */ import zi;
/*    */ import zk;
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ public class Stack
/*    */   extends zk
/*    */ {
/* 19 */   private int ID = 0;
/* 20 */   private String Name = "";
/*    */   private boolean Item_Block;
/*    */   
/*    */   public Stack(int id, yc mat, String Name, int Id, boolean isBlock) {
/* 24 */     super(id, mat);
/* 25 */     this.cw = 64;
/* 26 */     a(Base.tabStackPack);
/* 27 */     this.Item_Block = isBlock;
/* 28 */     this.Name = Name;
/* 29 */     this.ID = Id;
/*    */   }
/*    */ 
/*    */ 
/*    */   
/*    */   public boolean a(yd par1ItemStack, ue par2EntityPlayer, abv par3World, int par4, int par5, int par6, int par7, float par8, float par9, float par10) {
/* 35 */     if (!par3World.I) {
/*    */       
/* 37 */       if (this.Item_Block && 
/* 38 */         StackMethod.placeFromStack(par1ItemStack, par2EntityPlayer, par3World, par4, par5, par6, par7, this.ID, true)) {
/* 39 */         return true;
/*    */       }
/* 41 */       return false;
/*    */     } 
/*    */     
/* 44 */     return false;
/*    */   }
/*    */ 
/*    */   
/*    */   @SideOnly(Side.CLIENT)
/*    */   public boolean e(yd par1ItemStack) {
/* 50 */     return false;
/*    */   }
/*    */ 
/*    */ 
/*    */   
/*    */   public zi c_(yd par1ItemStack) {
/* 56 */     return null;
/*    */   }
/*    */ 
/*    */ 
/*    */   
/*    */   public boolean a(yd par1ItemStack, yd par2ItemStack) {
/* 62 */     return false;
/*    */   }
/*    */ 
/*    */ 
/*    */   
/*    */   public String l(yd par1ItemStack) {
/* 68 */     return this.Name;
/*    */   }
/*    */ }


/* Location:              C:\Users\Sealab\Desktop\Preservation\StackPack\compiled\!\sealab\mods\stackpack\code\Stack.class
 * Java compiler version: 6 (50.0)
 * JD-Core Version:       1.1.3
 */