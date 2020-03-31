/*    */ package sealab.mods.stackpack.code;
/*    */ 
/*    */ import cpw.mods.fml.common.event.FMLPreInitializationEvent;
/*    */ import net.minecraftforge.common.Configuration;
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ 
/*    */ public class Config
/*    */ {
/*    */   public static int StackerID;
/*    */   public static int ConverterID;
/*    */   public static int StackPackID;
/*    */   public static int dirtID;
/*    */   public static int sandID;
/*    */   public static int gravelID;
/*    */   public static int goreID;
/*    */   public static int ioreID;
/*    */   public static int glassID;
/*    */   public static int lapisBlockID;
/*    */   public static int gblockID;
/*    */   public static int iblockID;
/*    */   public static int eblockID;
/*    */   public static int stoneID;
/*    */   public static int rFleshID;
/*    */   
/*    */   public static void loadConfig(FMLPreInitializationEvent e) {
/* 37 */     Configuration config = new Configuration(e.getSuggestedConfigurationFile());
/* 38 */     config.load();
/*    */     
/* 40 */     StackerID = config.getItem("Packer", 10201).getInt();
/* 41 */     ConverterID = config.getItem("Converer", 10202).getInt();
/* 42 */     StackPackID = config.getItem("Cobblestone Stackpack", 10203).getInt();
/* 43 */     dirtID = config.getItem("Dirt StackPack", 10205).getInt();
/* 44 */     sandID = config.getItem("Sand StackPack", 10207).getInt();
/* 45 */     gravelID = config.getItem("Gravel StackPack", 10209).getInt();
/* 46 */     goreID = config.getItem("Gold Ore StackPack", 10211).getInt();
/* 47 */     ioreID = config.getItem("Iron Ore StackPack", 10213).getInt();
/* 48 */     glassID = config.getItem("Glass StackPack", 10215).getInt();
/* 49 */     lapisBlockID = config.getItem("Lapis Block StackPack", 10217).getInt();
/* 50 */     gblockID = config.getItem("Gold Block StackPack", 10219).getInt();
/* 51 */     iblockID = config.getItem("Iron Block StackPack", 10221).getInt();
/* 52 */     eblockID = config.getItem("Emerald Block StackPack", 10223).getInt();
/* 53 */     stoneID = config.getItem("Stone StackPack", 10200).getInt();
/* 54 */     rFleshID = config.getItem("Rotten Flesh StackPack", 10224).getInt();
/* 55 */     coalID = config.getItem("Coal StackPack", 10225).getInt();
/* 56 */     iIngotID = config.getItem("Iron Ingot StackPack", 10226).getInt();
/* 57 */     gIngotID = config.getItem("Gold Ingot StackPack", 10227).getInt();
/* 58 */     redstoneID = config.getItem("Redstone StackPack", 10228).getInt();
/* 59 */     glowstoneID = config.getItem("Glowstone StackPack", 10229).getInt();
/* 60 */     netherrackID = config.getItem("Netherrack StackPack", 10230).getInt();
/* 61 */     soulsandID = config.getItem("Soul Sand StackPack", 10231).getInt();
/* 62 */     glowdustID = config.getItem("Glowstone Dust StackPack", 10232).getInt();
/* 63 */     quartzID = config.getItem("Nether Quartz StackPack", 10233).getInt();
/* 64 */     woodID = config.getItem("Wood StackPack", 10234).getInt();
/* 65 */     mossID = config.getItem("MossyCobble StackPack", 10235).getInt();
/* 66 */     diamondID = config.getItem("Diamond StackPack", 10236).getInt();
/* 67 */     dblockID = config.getItem("Diamond Block StackPack", 10237).getInt();
/* 68 */     stickID = config.getItem("Stick StackPack", 10238).getInt();
/* 69 */     stringID = config.getItem("String StackPack", 10239).getInt();
/* 70 */     arrowID = config.getItem("Arrow StackPack", 10240).getInt();
/*    */     
/* 72 */     config.save();
/*    */   }
/*    */   
/*    */   public static int coalID;
/*    */   public static int iIngotID;
/*    */   public static int gIngotID;
/*    */   public static int redstoneID;
/*    */   public static int glowstoneID;
/*    */   public static int netherrackID;
/*    */   public static int soulsandID;
/*    */   public static int glowdustID;
/*    */   public static int quartzID;
/*    */   public static int woodID;
/*    */   public static int mossID;
/*    */   public static int diamondID;
/*    */   public static int dblockID;
/*    */   public static int stickID;
/*    */   public static int stringID;
/*    */   public static int arrowID;
/*    */ }


// Note: FUCK having to deal with minecraft's IDs anymore. Thank god we're past those dark times.

/* Location:              C:\Users\Sealab\Desktop\Preservation\StackPack\compiled\!\sealab\mods\stackpack\code\Config.class
 * Java compiler version: 6 (50.0)
 * JD-Core Version:       1.1.3
 */