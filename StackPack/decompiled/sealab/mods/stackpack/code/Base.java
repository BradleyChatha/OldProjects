/*     */ package sealab.mods.stackpack.code;
/*     */ 
/*     */ import aqw;
/*     */ import cpw.mods.fml.common.Mod;
/*     */ import cpw.mods.fml.common.Mod.Init;
/*     */ import cpw.mods.fml.common.Mod.Instance;
/*     */ import cpw.mods.fml.common.Mod.PreInit;
/*     */ import cpw.mods.fml.common.SidedProxy;
/*     */ import cpw.mods.fml.common.event.FMLInitializationEvent;
/*     */ import cpw.mods.fml.common.event.FMLPreInitializationEvent;
/*     */ import cpw.mods.fml.common.network.NetworkMod;
/*     */ import cpw.mods.fml.common.registry.GameRegistry;
/*     */ import cpw.mods.fml.common.registry.LanguageRegistry;
/*     */ import net.minecraftforge.common.EnumHelper;
/*     */ import wv;
/*     */ import yb;
/*     */ import yc;
/*     */ import yd;
/*     */ 
/*     */ 
/*     */ @Mod(modid = "Sealab_StackPack", name = "StackPack", version = "1.6.2")
/*     */ @NetworkMod(clientSideRequired = true, serverSideRequired = false)
/*     */ public class Base
/*     */ {
/*  25 */   public static yc stacker = EnumHelper.addToolMaterial("Stacker", 0, 64, 1.0F, 1.0F, 1);
/*  26 */   public static yc packer = EnumHelper.addToolMaterial("Packer", 0, 128, 0.0F, 0.0F, 14);
/*     */   
/*     */   public static yb Stacker;
/*     */   
/*     */   public static yb cobbleStackItem;
/*     */   public static yb dirtStackItem;
/*     */   public static yb sandStackItem;
/*     */   public static yb gravelStackItem;
/*     */   public static yb goreStackItem;
/*     */   public static yb ioreStackItem;
/*     */   public static yb glassStackItem;
/*     */   public static yb lapisStackItem;
/*     */   public static yb gblockStackItem;
/*     */   public static yb iblockStackItem;
/*     */   public static yb eblockStackItem;
/*     */   public static yb stoneStackItem;
/*     */   public static yb converter;
/*     */   public static yb rFlesh;
/*     */   public static yb coalStack;
/*     */   public static yb iIngot;
/*     */   public static yb gIngot;
/*     */   public static yb redstoneStack;
/*     */   public static yb glowstoneStack;
/*     */   public static yb netherRack;
/*     */   public static yb soulSand;
/*     */   public static yb glowstoneDustStack;
/*     */   public static yb quartzStack;
/*     */   public static yb woodStack;
/*     */   public static yb mossCobStack;
/*     */   public static yb diamondStack;
/*     */   public static yb dblockStack;
/*     */   public static yb arrowStack;
/*     */   public static yb stringStack;
/*     */   public static yb stickStack;
/*     */   @Instance
/*     */   public static Base instance;
/*     */   @SidedProxy(clientSide = "sealab.mods.stackpack.code.ClientProxy", serverSide = "sealab.mods.stackpack.code.CommonProxy")
/*     */   public static CommonProxy proxy;
/*     */   
/*     */   @PreInit
/*     */   public void preInit(FMLPreInitializationEvent event) {
/*  67 */     Config cc = new Config();
/*  68 */     Config.loadConfig(event);
/*     */     
/*  70 */     Stacker = (new Stacker(Config.StackerID, packer)).b("STpacker");
/*  71 */     converter = (new Converter(Config.ConverterID)).b("STconverter");
/*  72 */     cobbleStackItem = (new Stack(Config.StackPackID, stacker, "Cobblestone StackPack", aqw.B.cF, true)).b("STcstone");
/*  73 */     dirtStackItem = (new Stack(Config.dirtID, stacker, "Dirt StackPack", aqw.A.cF, true)).b("STdirt");
/*  74 */     sandStackItem = (new Stack(Config.sandID, stacker, "Sand StackPack", aqw.J.cF, true)).b("STsand");
/*  75 */     gravelStackItem = (new Stack(Config.gravelID, stacker, "Gravel StackPack", aqw.K.cF, true)).b("STgravel");
/*  76 */     goreStackItem = (new Stack(Config.goreID, stacker, "Gold Ore StackPack", aqw.L.cF, true)).b("STg_ore");
/*  77 */     ioreStackItem = (new Stack(Config.ioreID, stacker, "Iron Ore StackPack", aqw.M.cF, true)).b("STi_ore");
/*  78 */     glassStackItem = (new Stack(Config.glassID, stacker, "Glass StackPack", aqw.R.cF, true)).b("STglass");
/*  79 */     lapisStackItem = (new Stack(Config.lapisBlockID, stacker, "Lapis Block StackPack", aqw.T.cF, true)).b("STlapis_block");
/*  80 */     gblockStackItem = (new Stack(Config.gblockID, stacker, "Gold Block StackPack", aqw.am.cF, true)).b("STg_block");
/*  81 */     iblockStackItem = (new Stack(Config.iblockID, stacker, "Iron Block StackPack", aqw.an.cF, true)).b("STi_block");
/*  82 */     eblockStackItem = (new Stack(Config.eblockID, stacker, "Emerald Block StackPack", aqw.ca.cF, true)).b("STe_block");
/*  83 */     stoneStackItem = (new Stack(Config.stoneID, stacker, "Stone StackPack", aqw.y.cF, true)).b("STstone");
/*  84 */     rFlesh = (new Stack(Config.rFleshID, stacker, "Rotten Flesh StackPack", 0, false)).b("STrotFlesh");
/*  85 */     coalStack = (new Stack(Config.coalID, stacker, "Coal StackPack", 0, false)).b("STcoal");
/*  86 */     iIngot = (new Stack(Config.iIngotID, stacker, "Iron Ingot StackPack", 0, false)).b("STironIngot");
/*  87 */     gIngot = (new Stack(Config.gIngotID, stacker, "Gold Ingot StackPack", 0, false)).b("STgoldIngot");
/*  88 */     redstoneStack = (new Stack(Config.redstoneID, stacker, "Redstone StackPack", 0, false)).b("STredstone");
/*  89 */     glowstoneDustStack = (new Stack(Config.glowdustID, stacker, "Glowstone StackPack", 0, false)).b("STglowdust");
/*  90 */     quartzStack = (new Stack(Config.quartzID, stacker, "Quartz Stackpack", 0, false)).b("STquartz");
/*  91 */     glowstoneStack = (new Stack(Config.glowstoneID, stacker, "Glowstone Block StackPack", aqw.bi.cF, true)).b("STglowstone");
/*  92 */     netherRack = (new Stack(Config.netherrackID, stacker, "Netherrack StackPack", aqw.bg.cF, true)).b("STnetherrack");
/*  93 */     soulSand = (new Stack(Config.soulsandID, stacker, "SoulSand StackPack", aqw.bh.cF, true)).b("STsoul");
/*  94 */     woodStack = (new Stack(Config.woodID, stacker, "Wood StackPack", aqw.O.cF, true)).b("STwood");
/*  95 */     mossCobStack = (new Stack(Config.mossID, stacker, "Mossy Cobblestone StackPack", aqw.at.cF, true)).b("STmoss");
/*  96 */     diamondStack = (new Stack(Config.diamondID, stacker, "Diamond StackPack", 0, false)).b("STdiamond");
/*  97 */     dblockStack = (new Stack(Config.dblockID, stacker, "Diamond Block StackPack", aqw.aC.cF, true)).b("STd_block");
/*  98 */     stickStack = (new Stack(Config.stickID, stacker, "Stick StackPack", 0, false)).b("STstick");
/*  99 */     arrowStack = (new Stack(Config.arrowID, stacker, "Arrow StackPack", 0, false)).b("STarrow");
/* 100 */     stringStack = (new Stack(Config.stringID, stacker, "String StackPack", 0, false)).b("STstring");
/*     */   }
/*     */   
/* 103 */   public static wv tabStackPack = new wv("tabStackPack")
/*     */     {
/*     */       public yd getIconItemStack()
/*     */       {
/* 107 */         return new yd(Base.Stacker, 1, 0);
/*     */       }
/*     */     };
/*     */ 
/*     */   
/*     */   @Init
/*     */   public void load(FMLInitializationEvent event) {
/* 114 */     LanguageRegistry.addName(Stacker, "Packer");
/* 115 */     LanguageRegistry.addName(converter, "Converter");
/* 116 */     LanguageRegistry.instance().addStringLocalization("itemGroup.tabStackPack", "en_US", "StackPack");
/*     */     
/* 118 */     registerRecipe();
/*     */   }
/*     */ 
/*     */   
/*     */   public void registerRecipe() {
/* 123 */     itemReg();
/*     */   }
/*     */ 
/*     */   
/*     */   private void itemReg() {
/* 128 */     GameRegistry.addRecipe(new yd(converter), new Object[] { "sss", "wpw", "sss", Character.valueOf('s'), yb.U, Character.valueOf('w'), aqw.O, Character.valueOf('p'), Stacker });
/*     */ 
/*     */     
/* 131 */     GameRegistry.addRecipe(new yd(Stacker), new Object[] { "isi", "ppp", "ici", Character.valueOf('i'), yb.q, Character.valueOf('s'), yb.M, Character.valueOf('p'), yb.aM, Character.valueOf('c'), aqw.az });
/*     */ 
/*     */     
/* 134 */     GameRegistry.addRecipe(new yd(aqw.y, 64), new Object[] { "s", Character.valueOf('s'), stoneStackItem });
/*     */ 
/*     */     
/* 137 */     GameRegistry.addRecipe(new yd(aqw.B, 64), new Object[] { "s", Character.valueOf('s'), cobbleStackItem });
/*     */ 
/*     */     
/* 140 */     GameRegistry.addRecipe(new yd(aqw.A, 64), new Object[] { "s", Character.valueOf('s'), dirtStackItem });
/*     */ 
/*     */     
/* 143 */     GameRegistry.addRecipe(new yd(aqw.J, 64), new Object[] { "s", Character.valueOf('s'), sandStackItem });
/*     */ 
/*     */     
/* 146 */     GameRegistry.addRecipe(new yd(aqw.K, 64), new Object[] { "s", Character.valueOf('s'), gravelStackItem });
/*     */ 
/*     */     
/* 149 */     GameRegistry.addRecipe(new yd(aqw.L, 64), new Object[] { "s", Character.valueOf('s'), goreStackItem });
/*     */ 
/*     */     
/* 152 */     GameRegistry.addRecipe(new yd(aqw.M, 64), new Object[] { "s", Character.valueOf('s'), ioreStackItem });
/*     */ 
/*     */     
/* 155 */     GameRegistry.addRecipe(new yd(aqw.R, 64), new Object[] { "s", Character.valueOf('s'), glassStackItem });
/*     */ 
/*     */     
/* 158 */     GameRegistry.addRecipe(new yd(aqw.T, 64), new Object[] { "s", Character.valueOf('s'), lapisStackItem });
/*     */ 
/*     */     
/* 161 */     GameRegistry.addRecipe(new yd(aqw.am, 64), new Object[] { "s", Character.valueOf('s'), gblockStackItem });
/*     */ 
/*     */     
/* 164 */     GameRegistry.addRecipe(new yd(aqw.an, 64), new Object[] { "s", Character.valueOf('s'), iblockStackItem });
/*     */ 
/*     */     
/* 167 */     GameRegistry.addRecipe(new yd(aqw.ca, 64), new Object[] { "s", Character.valueOf('s'), eblockStackItem });
/*     */ 
/*     */     
/* 170 */     GameRegistry.addRecipe(new yd(yb.bo, 64), new Object[] { "s", Character.valueOf('s'), rFlesh });
/*     */ 
/*     */     
/* 173 */     GameRegistry.addRecipe(new yd(yb.o, 64), new Object[] { "s", Character.valueOf('s'), coalStack });
/*     */ 
/*     */     
/* 176 */     GameRegistry.addRecipe(new yd(yb.q, 64), new Object[] { "s", Character.valueOf('s'), iIngot });
/*     */ 
/*     */     
/* 179 */     GameRegistry.addRecipe(new yd(yb.r, 64), new Object[] { "s", Character.valueOf('s'), gIngot });
/*     */ 
/*     */     
/* 182 */     GameRegistry.addRecipe(new yd(yb.aE, 64), new Object[] { "s", Character.valueOf('s'), redstoneStack });
/*     */ 
/*     */     
/* 185 */     GameRegistry.addRecipe(new yd(yb.aV, 64), new Object[] { "s", Character.valueOf('s'), glowstoneDustStack });
/*     */ 
/*     */     
/* 188 */     GameRegistry.addRecipe(new yd(aqw.bi, 64), new Object[] { "s", Character.valueOf('s'), glowstoneStack });
/*     */ 
/*     */     
/* 191 */     GameRegistry.addRecipe(new yd(aqw.bh, 64), new Object[] { "s", Character.valueOf('s'), soulSand });
/*     */ 
/*     */     
/* 194 */     GameRegistry.addRecipe(new yd(aqw.bg, 64), new Object[] { "s", Character.valueOf('s'), netherRack });
/*     */ 
/*     */     
/* 197 */     GameRegistry.addRecipe(new yd(yb.cb, 64), new Object[] { "s", Character.valueOf('s'), quartzStack });
/*     */ 
/*     */     
/* 200 */     GameRegistry.addRecipe(new yd(aqw.O, 64), new Object[] { "s", Character.valueOf('s'), woodStack });
/*     */ 
/*     */     
/* 203 */     GameRegistry.addRecipe(new yd(aqw.at, 64), new Object[] { "s", Character.valueOf('s'), mossCobStack });
/*     */ 
/*     */     
/* 206 */     GameRegistry.addRecipe(new yd(yb.p, 64), new Object[] { "s", Character.valueOf('s'), diamondStack });
/*     */ 
/*     */     
/* 209 */     GameRegistry.addRecipe(new yd(aqw.aC, 64), new Object[] { "s", Character.valueOf('s'), dblockStack });
/*     */   }
/*     */ }


/* Location:              C:\Users\Sealab\Desktop\Preservation\StackPack\compiled\!\sealab\mods\stackpack\code\Base.class
 * Java compiler version: 6 (50.0)
 * JD-Core Version:       1.1.3
 */