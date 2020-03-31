/*     */ package sealab.mods.stackpack.code;
/*     */ 
/*     */ import abv;
/*     */ import aqw;
/*     */ import oe;
/*     */ import ue;
/*     */ import yb;
/*     */ import yd;
/*     */ 
/*     */ public class StackMethod
/*     */ {
/*     */   public static void Stacker(yd par1ItemStack, abv par2World, ue par3EntityPlayer, aqw par4Block, yb par5Item) {
/*  13 */     int stone = 0;
/*  14 */     for (int i = 1; i <= 64; i++) {
/*     */ 
/*     */       
/*  17 */       if (par3EntityPlayer.bn.c(new yd(par4Block))) {
/*     */ 
/*     */ 
/*     */         
/*  21 */         par3EntityPlayer.bn.d(par4Block.cF);
/*  22 */         stone++;
/*  23 */         if (stone == 64)
/*     */         {
/*  25 */           par3EntityPlayer.bn.a(new yd(par5Item));
/*     */         }
/*     */       } 
/*     */     } 
/*     */ 
/*     */     
/*  31 */     if (stone != 64 && stone != 0)
/*     */     {
/*  33 */       par3EntityPlayer.bn.a(new yd(par4Block, stone));
/*     */     }
/*     */   }
/*     */ 
/*     */ 
/*     */   
/*     */   public static void StackerItem(yd par1ItemStack, abv par2World, ue par3EntityPlayer, yb par4Block, yb par5Item) {
/*  40 */     int stone = 0;
/*  41 */     for (int i = 1; i <= 64; i++) {
/*     */ 
/*     */       
/*  44 */       if (par3EntityPlayer.bn.c(new yd(par4Block))) {
/*     */ 
/*     */ 
/*     */         
/*  48 */         par3EntityPlayer.bn.d(par4Block.cv);
/*  49 */         stone++;
/*  50 */         if (stone == 64)
/*     */         {
/*  52 */           par3EntityPlayer.bn.a(new yd(par5Item));
/*     */         }
/*     */       } 
/*     */     } 
/*     */ 
/*     */     
/*  58 */     if (stone != 64 && stone != 0)
/*     */     {
/*  60 */       par3EntityPlayer.bn.a(new yd(par4Block, stone));
/*     */     }
/*     */   }
/*     */ 
/*     */ 
/*     */   
/*     */   public static boolean placeFromStack(yd par1ItemStack, ue par2EntityPlayer, abv par3World, int par4, int par5, int par6, int par7, int blockID, boolean damage) {
/*  67 */     long x1 = Math.round(par2EntityPlayer.u);
/*  68 */     long y1 = Math.round(par2EntityPlayer.v);
/*  69 */     long z1 = Math.round(par2EntityPlayer.w);
/*     */     
/*  71 */     int X = Math.round((float)x1);
/*  72 */     int Y = Math.round((float)y1);
/*  73 */     int Z = Math.round((float)z1);
/*  74 */     if (par7 == 0)
/*     */     {
/*  76 */       par5--;
/*     */     }
/*     */     
/*  79 */     if (par7 == 1)
/*     */     {
/*  81 */       par5++;
/*     */     }
/*     */     
/*  84 */     if (par7 == 2) {
/*     */       
/*  86 */       par6--;
/*  87 */       if (Z == par6) {
/*  88 */         return false;
/*     */       }
/*     */     } 
/*  91 */     if (par7 == 3) {
/*     */       
/*  93 */       par6++;
/*  94 */       if (Z == par6) {
/*  95 */         return false;
/*     */       }
/*     */     } 
/*  98 */     if (par7 == 4) {
/*     */       
/* 100 */       par4--;
/* 101 */       if (X == par4) {
/* 102 */         return false;
/*     */       }
/*     */     } 
/* 105 */     if (par7 == 5) {
/*     */       
/* 107 */       par4++;
/* 108 */       if (X == par4) {
/* 109 */         return false;
/*     */       }
/*     */     } 
/* 112 */     int var11 = par3World.a(par4, par5, par6);
/*     */     
/* 114 */     if (var11 == 0)
/*     */     {
/* 116 */       if (par3World.f(par4, par5, par6, blockID, 0, var11)) {
/*     */         
/* 118 */         if (damage)
/* 119 */           par1ItemStack.a(1, (oe)par2EntityPlayer); 
/* 120 */         par3World.a(par4, par5, par6, "note.harp", 2.0F, 2.0F);
/* 121 */         return true;
/*     */       } 
/*     */     }
/* 124 */     return false;
/*     */   }
/*     */ 
/*     */   
/*     */   public static boolean Convert(yd par1ItemStack, abv par2World, ue par3EntityPlayer, aqw par4Block, int ID, int ID2) {
/* 129 */     int stone = 0;
/* 130 */     for (int i = 1; i <= 64; i++) {
/*     */       
/* 132 */       if (par3EntityPlayer.bn.c(new yd(par4Block))) {
/*     */         
/* 134 */         par3EntityPlayer.bn.d(par4Block.cF);
/* 135 */         stone++;
/*     */       } 
/*     */     } 
/*     */     
/* 139 */     if (stone != 0)
/*     */     {
/* 141 */       par3EntityPlayer.bn.a(new yd(par4Block, stone, ID2));
/*     */     }
/*     */     
/* 144 */     return false;
/*     */   }
/*     */ }


/* Location:              C:\Users\Sealab\Desktop\Preservation\StackPack\compiled\!\sealab\mods\stackpack\code\StackMethod.class
 * Java compiler version: 6 (50.0)
 * JD-Core Version:       1.1.3
 */