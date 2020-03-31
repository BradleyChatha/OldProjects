using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Audio;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace J_Platformer
{
	public class Main : Game
	{
		public const string VERSION = "Alpha 1.0";

		public const int TILE_SIZE = 32;

		private GraphicsDeviceManager graphics;

		private SpriteBatch spriteBatch;

		private Texture2D Wall;

		private Texture2D KeyT;

		private Texture2D Door;

		private Texture2D Gem;

		private SpriteFont Debug;

		private SpriteFont Large;

		private SpriteFont Test;

		private Texture2D ProjectileUp;

		private Texture2D ProjectileRight;

		private Texture2D ProjectileDown;

		private Texture2D ProjectileLeft;

		private Texture2D ShooterUp;

		private Texture2D ShooterRight;

		private Texture2D ShooterDown;

		private Texture2D ShooterLeft;

		private Texture2D Background;

		private KeyboardState Key;

		private KeyboardState PrevKey;

		private List<Tile> Tiles = new List<Tile>();

		private Tile[] Info;

		private SoundEffectInstance BGMuse;

		private TimeSpan elapsedTime = TimeSpan.Zero;

		private SoundEffectInstance Gem_Pickup;

		private string Level_Name = "";

		private string Old_Name;

		public Player Player;

		public List<Projectile> Projectiles = new List<Projectile>();

		private int Count;

		private int Score;

		private int FrameRate;

		private int FrameCounter;

		private int PlayerX;

		private int PlayerY;

		private bool PlayerOnGround;

		private bool PlayerWalkRight;

		private bool PlayerWalkLeft;

		private bool PlayerCanJump;

		private bool Active = true;

		private bool Last_Map;

		private bool Render = true;

		private bool UpdateMap = true;

		private bool Changed;

		private bool TitleScreen = true;

		public Main()
		{
			graphics = new GraphicsDeviceManager(this);
			base.Content.RootDirectory = "Content";
			base.IsMouseVisible = true;
			SoundEffect Music = base.Content.Load<SoundEffect>("BGMusic");
			SoundEffectInstance Instance = Music.CreateInstance();
			Instance.IsLooped = true;
			BGMuse = Instance;
			graphics.PreferredBackBufferWidth = 1248;
			graphics.PreferredBackBufferHeight = 800;
		}

		protected override void Initialize()
		{
			base.Initialize();
		}

		protected override void LoadContent()
		{
			spriteBatch = new SpriteBatch(base.GraphicsDevice);
			Wall = base.Content.Load<Texture2D>("Wall");
			KeyT = Load("Key");
			Door = Load("Door");
			Gem = Load("Gem");
			Background = Load("Background");
			Debug = base.Content.Load<SpriteFont>("Debug");
			Large = base.Content.Load<SpriteFont>("Large");
			Test = base.Content.Load<SpriteFont>("Test");
			ProjectileUp = Load("Multi//ProjectileUp");
			ProjectileRight = Load("Multi//ProjectileRight");
			ProjectileDown = Load("Multi//ProjectileDown");
			ProjectileLeft = Load("Multi//ProjectileLeft");
			ShooterUp = Load("Multi//ShooterUp");
			ShooterRight = Load("Multi//ShooterRight");
			ShooterDown = Load("Multi//ShooterDown");
			ShooterLeft = Load("Multi//ShooterLeft");
			Gem_Pickup = base.Content.Load<SoundEffect>("Sounds//Pickup").CreateInstance();
			Info = new Tile[22];
			Info[0] = new Tile(Wall, Vector2.Zero, Color.Black, 0, isSolid: true, TileType.Block);
			Info[1] = new Tile(Wall, Vector2.Zero, Color.Red, 1, isSolid: true, TileType.Block);
			Info[2] = new Tile(Wall, Vector2.Zero, Color.Blue, 2, isSolid: true, TileType.Block);
			Info[3] = new Tile(Load("Spike"), Vector2.Zero, Color.Black, 3, isSolid: true, TileType.Killable);
			Info[4] = new Tile(Gem, Vector2.Zero, Color.Gold, 4, isSolid: false, TileType.PickupGem)
			{
				GemScore = 1
			};
			Info[5] = new Tile(Door, Vector2.Zero, Color.Gold, 5, isSolid: true, TileType.Door)
			{
				DoorKeyID = 1
			};
			Info[6] = new Tile(KeyT, Vector2.Zero, Color.Gold, 6, isSolid: false, TileType.Key)
			{
				DoorKeyID = 1
			};
			Info[7] = new Tile(Gem, Vector2.Zero, Color.Cyan, 7, isSolid: false, TileType.PickupGem)
			{
				GemScore = 5
			};
			Info[8] = new Tile(KeyT, Vector2.Zero, Color.Cyan, 8, isSolid: false, TileType.Key)
			{
				DoorKeyID = 2
			};
			Info[9] = new Tile(Door, Vector2.Zero, Color.Cyan, 9, isSolid: true, TileType.Door)
			{
				DoorKeyID = 2
			};
			Info[10] = new Tile(Gem, Vector2.Zero, Color.Crimson, 10, isSolid: false, TileType.PickupGem)
			{
				GemScore = 10
			};
			Info[11] = new Tile(Door, Vector2.Zero, Color.Red, 11, isSolid: true, TileType.Door)
			{
				DoorKeyID = 3
			};
			Info[12] = new Tile(KeyT, Vector2.Zero, Color.Red, 12, isSolid: false, TileType.Key)
			{
				DoorKeyID = 3
			};
			Info[13] = new Tile(Gem, Vector2.Zero, Color.Indigo, 13, isSolid: false, TileType.PickupGem)
			{
				GemScore = 50
			};
			Info[14] = new Tile(ShooterUp, Vector2.Zero, Color.DarkSlateGray, 14, isSolid: true, TileType.Shooter)
			{
				ProjDirection = Direction.Up
			};
			Info[15] = new Tile(ShooterRight, Vector2.Zero, Color.DarkSlateGray, 15, isSolid: true, TileType.Shooter)
			{
				ProjDirection = Direction.Right
			};
			Info[16] = new Tile(ShooterDown, Vector2.Zero, Color.DarkSlateGray, 16, isSolid: true, TileType.Shooter)
			{
				ProjDirection = Direction.Down
			};
			Info[17] = new Tile(ShooterLeft, Vector2.Zero, Color.DarkSlateGray, 17, isSolid: true, TileType.Shooter)
			{
				ProjDirection = Direction.Left
			};
			Info[18] = new Tile(Wall, Vector2.Zero, Color.DarkMagenta, 18, isSolid: false, TileType.Checkpoint);
			Info[19] = new Tile(Load("Powerups//FeatherFall"), Vector2.Zero, Color.White, 19, isSolid: false, TileType.PickupPowerup)
			{
				Power = Powerups.FeatherFall
			};
			Info[20] = new Tile(Load("Powerups//Jump"), Vector2.Zero, Color.White, 20, isSolid: false, TileType.PickupPowerup)
			{
				Power = Powerups.High_Jump
			};
			Info[21] = new Tile(Load("Switch"), Vector2.Zero, Color.DarkBlue, 21, isSolid: false, TileType.Toggleable);
			Key = Keyboard.GetState();
			Player = new Player(base.Content.Load<Texture2D>("Player"), Vector2.Zero, Color.White, 0);
			Player.hitSpike += Player_hitSpike;
			Player.openDoor += Player_openDoor;
			Player.playSound += Player_playSound;
			Player.Toggle += Player_Toggle;
			BGMuse.Play();
		}

		protected override void Update(GameTime gameTime)
		{
			if (Keyboard.GetState().IsKeyDown(Keys.Escape))
			{
				Exit();
			}
			PrevKey = Key;
			Key = Keyboard.GetState();
			if (!Last_Map)
			{
				Active = true;
			}
			if (Keyboard.GetState().IsKeyDown(Keys.Enter) && TitleScreen)
			{
				TitleScreen = false;
			}
			elapsedTime += gameTime.ElapsedGameTime;
			if (elapsedTime > TimeSpan.FromSeconds(1.0))
			{
				elapsedTime -= TimeSpan.FromSeconds(1.0);
				FrameRate = FrameCounter;
				FrameCounter = 0;
			}
			if (Active && base.IsActive && !TitleScreen)
			{
				if (Player.hasStopped && !Last_Map)
				{
					GetLevel(Increment: true);
				}
				if (UpdateMap)
				{
					for (int i = 0; i < Projectiles.ToArray().Length; i++)
					{
						Projectiles[i].Update(gameTime, this);
					}
					for (int j = 0; j < Projectiles.ToArray().Length; j++)
					{
						if (Projectiles[j].Position.Y < (float)(-Projectiles[j].Texture.Height) || Projectiles[j].Position.Y > (float)(base.GraphicsDevice.Viewport.Height + Projectiles[j].Texture.Height) || Projectiles[j].Position.X > (float)(base.GraphicsDevice.Viewport.Width + Projectiles[j].Texture.Width) || Projectiles[j].Position.X < (float)(-Projectiles[j].Texture.Width))
						{
							Projectiles.Remove(Projectiles[j]);
						}
					}
				}
				foreach (Tile T in Tiles)
				{
					Texture2D Proj = null;
					if (T.Type == TileType.Shooter)
					{
						Proj = ((T.ProjDirection == Direction.Up) ? ProjectileUp : ((T.ProjDirection == Direction.Right) ? ProjectileRight : ((T.ProjDirection != Direction.Down) ? ProjectileLeft : ProjectileDown)));
						if (UpdateMap)
						{
							T.Update(gameTime, Projectiles, ref Proj);
						}
					}
					if (T.Type == TileType.Toggleable && UpdateMap)
					{
						T.Update(gameTime, Projectiles, ref Proj);
					}
				}
				Player.Update(gameTime, Tiles, base.GraphicsDevice, Projectiles, Last_Map, ref PlayerX, ref PlayerY, ref PlayerOnGround, ref PlayerWalkRight, ref PlayerWalkLeft, ref PlayerCanJump);
				if (Keyboard.GetState().IsKeyDown(Keys.R) && PrevKey.IsKeyUp(Keys.R))
				{
					GetLevel(Increment: false);
				}
				if (Keyboard.GetState().IsKeyDown(Keys.S) && PrevKey.IsKeyUp(Keys.S) && BGMuse.State == SoundState.Playing)
				{
					BGMuse.Pause();
				}
				else if (Keyboard.GetState().IsKeyDown(Keys.S) && PrevKey.IsKeyUp(Keys.S))
				{
					BGMuse.Play();
				}
				if (Keyboard.GetState().IsKeyDown(Keys.P) && PrevKey.IsKeyUp(Keys.P) && Render)
				{
					setRender(Render: false);
					Render = false;
				}
				else if (Keyboard.GetState().IsKeyDown(Keys.P) && PrevKey.IsKeyUp(Keys.P))
				{
					setRender(Render: true);
					Render = true;
				}
				if (Keyboard.GetState().IsKeyDown(Keys.F1) && PrevKey.IsKeyUp(Keys.F1))
				{
					GetLevel(Increment: true);
				}
			}
			base.Update(gameTime);
		}

		protected override void Draw(GameTime gameTime)
		{
			base.GraphicsDevice.Clear(Color.White);
			spriteBatch.Begin();
			FrameCounter++;
			DrawTiles();
			if (Last_Map)
			{
				spriteBatch.DrawString(Large, "Congratulations, you have beaten the game", new Vector2(150f, 300f), Color.Purple);
			}
			spriteBatch.DrawString(Debug, "X:" + PlayerX, new Vector2(30f, 70f), Color.DarkGray);
			spriteBatch.DrawString(Debug, "Y:" + PlayerY, new Vector2(30f, 90f), Color.DarkGray);
			spriteBatch.DrawString(Debug, "CellX:" + PlayerX / 32, new Vector2(30f, 110f), Color.DarkGray);
			spriteBatch.DrawString(Debug, "CellY:" + PlayerY / 32, new Vector2(30f, 130f), Color.DarkGray);
			spriteBatch.DrawString(Debug, "MouseX:" + Mouse.GetState().X / 32, new Vector2(30f, 150f), Color.DarkGray);
			spriteBatch.DrawString(Debug, "MouseY:" + Mouse.GetState().Y / 32, new Vector2(30f, 170f), Color.DarkGray);
			spriteBatch.DrawString(Debug, "Tiles:" + Tiles.ToArray().Length, new Vector2(30f, 190f), Color.DarkGray);
			spriteBatch.DrawString(Debug, "Projectiles:" + Projectiles.ToArray().Length, new Vector2(30f, 210f), Color.DarkGray);
			spriteBatch.DrawString(Debug, "OnGround:" + PlayerOnGround, new Vector2(30f, 230f), Color.DarkGray);
			spriteBatch.DrawString(Debug, "WalkLeft:" + PlayerWalkLeft, new Vector2(30f, 250f), Color.DarkGray);
			spriteBatch.DrawString(Debug, "WalkRight:" + PlayerWalkRight, new Vector2(30f, 270f), Color.DarkGray);
			spriteBatch.DrawString(Debug, "CanJump:" + !PlayerCanJump, new Vector2(30f, 290f), Color.DarkGray);
			spriteBatch.DrawString(Debug, "Powerup:" + GetPowerName(Player.Powerup) + " " + Player.Powerup, new Vector2(30f, 310f), Color.DarkGray);
			spriteBatch.DrawString(Debug, string.Concat(FrameRate), new Vector2(0f, 450f), Color.DarkGray);
			if (!TitleScreen)
			{
				spriteBatch.DrawString(Debug, "Score: " + Player.Score, new Vector2(30f, 30f), Color.DarkGray);
				if (Count != new DirectoryInfo("Levels").GetFiles().Length)
				{
					spriteBatch.DrawString(Debug, "Level: " + Level_Name, new Vector2(30f, 50f), Color.DarkGray);
				}
				else
				{
					spriteBatch.DrawString(Debug, "Level: " + Level_Name + " (Final Level)", new Vector2(30f, 50f), Color.DarkGray);
				}
			}
			else
			{
				spriteBatch.Draw(Background, new Vector2(base.GraphicsDevice.Viewport.Width / 2 - Background.Width / 2 + 30, -150f), Color.White);
				spriteBatch.DrawString(Test, "Press ENTER to start", new Vector2((float)(base.GraphicsDevice.Viewport.Width / 2) - Test.MeasureString("Press ENTER to start").X / 2f, 600f), Color.Black);
				spriteBatch.DrawString(Debug, "Version: Alpha 1.0", new Vector2(0f, 770f), Color.Black);
			}
			spriteBatch.End();
			base.Draw(gameTime);
		}

		private void DrawTiles()
		{
			List<Tile> Shooters = new List<Tile>();
			foreach (Tile T2 in Tiles)
			{
				if (T2.ID != 1 && T2.shouldRender && T2.Type != TileType.Shooter)
				{
					spriteBatch.Draw(T2.Texture, T2.Position, T2.Color);
				}
				else if (T2.Type == TileType.Shooter)
				{
					Shooters.Add(T2);
				}
			}
			for (int i = 0; i < Projectiles.ToArray().Length; i++)
			{
				if (Projectiles[i].shouldRender)
				{
					Projectiles[i].Draw(spriteBatch);
				}
			}
			foreach (Tile T in Shooters)
			{
				spriteBatch.Draw(T.Texture, T.Position, T.Color);
			}
			if (Player.shouldRender)
			{
				spriteBatch.Draw(Player.Texture, Player.Position, Player.Color);
			}
		}

		private void GetLevel(bool Increment)
		{
			if (Last_Map)
			{
				return;
			}
			Old_Name = Level_Name;
			if (!Increment)
			{
				Player.Score = Score;
				Player.Ichi = Score + 20;
			}
			else
			{
				Score = Player.Score;
			}
			Tiles.Clear();
			Projectiles.Clear();
			if (Increment)
			{
				Count++;
			}
			Level_Name = Count.ToString();
			string[] Stuff2 = null;
			Tile toDelete = null;
			FileInfo toUse = null;
			DirectoryInfo FInfo = new DirectoryInfo("Levels");
			Player.Powerup = Powerups.None;
			foreach (FileInfo f in from fi in FInfo.GetFiles()
				orderby fi.Name
				select fi)
			{
				if (f.Name.Contains("Level_" + Count))
				{
					toUse = f;
					break;
				}
			}
			if (toUse == null)
			{
				Last_Map = true;
				Count--;
				return;
			}
			Stuff2 = File.ReadAllLines("Levels//" + toUse.Name);
			string[] array = Stuff2;
			foreach (string s in array)
			{
				string[] Data = s.Split(' ');
				if (s.StartsWith(";"))
				{
					string[] InnerData = Data[0].Split('=');
					if (InnerData.First().Contains("Update") && InnerData.Last().ToLower().Contains("false"))
					{
						UpdateMap = false;
						Changed = true;
					}
					if (InnerData.First().Contains("Name"))
					{
						Level_Name = InnerData.Last();
					}
					InnerData.First().Contains("DebugOnly");
				}
				if (Data.Length >= 3)
				{
					try
					{
						if (!Data[0].StartsWith(";"))
						{
							if (Info[Convert.ToInt32(Data[0])].Type != TileType.Shooter && Info[Convert.ToInt32(Data[0])].Type != TileType.Toggleable)
							{
								Tiles.Add(new Tile(Info[Convert.ToInt32(Data[0])].Texture ?? Info[0].Texture, new Vector2(Convert.ToInt32(Data[1]) * 32, Convert.ToInt32(Data[2]) * 32), Info[Convert.ToInt32(Data[0])].Color, Info[Convert.ToInt32(Data[0])].ID, Info[Convert.ToInt32(Data[0])].isSolid, Info[Convert.ToInt32(Data[0])].Type, Info[Convert.ToInt32(Data[0])].GemScore, Info[Convert.ToInt32(Data[0])].DoorKeyID, Info[Convert.ToInt32(Data[0])].Power));
							}
							else if (Info[Convert.ToInt32(Data[0])].Type == TileType.Shooter && Data.Length >= 4)
							{
								int Number2 = Convert.ToInt32(Data[0]);
								Tiles.Add(new Tile(Info[Number2].Texture ?? Info[0].Texture, new Vector2(Convert.ToInt32(Data[1]) * 32, Convert.ToInt32(Data[2]) * 32), Info[Number2].Color, Number2, Info[Number2].isSolid, Info[Number2].Type, Info[Number2].GemScore, Info[Number2].DoorKeyID, Info[Number2].Power)
								{
									TIMER_TIME = Convert.ToInt32(Data[3]),
									ProjDirection = Info[Number2].ProjDirection
								});
							}
							else if (Info[Convert.ToInt32(Data[0])].Type == TileType.Toggleable && Data.Length >= 5)
							{
								int Number = Convert.ToInt32(Data[0]);
								Tiles.Add(new Tile(Info[Number].Texture ?? Info[0].Texture, new Vector2(Convert.ToInt32(Data[1]) * 32, Convert.ToInt32(Data[2]) * 32), Info[Number].Color, Number, Info[Number].isSolid, Info[Number].Type, Info[Number].GemScore, Info[Number].DoorKeyID, Info[Number].Power)
								{
									lever_X = Convert.ToInt32(Data[3]),
									lever_Y = Convert.ToInt32(Data[4])
								});
							}
						}
					}
					catch (IndexOutOfRangeException)
					{
						Data[0] = "4";
						Tiles.Add(new Tile(Info[Convert.ToInt32(Data[0])].Texture ?? Info[0].Texture, new Vector2(Convert.ToInt32(Data[1]) * 32, Convert.ToInt32(Data[2]) * 32), Color.Black, Info[Convert.ToInt32(Data[0])].ID, Info[Convert.ToInt32(Data[0])].isSolid, Info[Convert.ToInt32(Data[0])].Type, 0, Info[Convert.ToInt32(Data[0])].DoorKeyID, Info[Convert.ToInt32(Data[0])].Power));
					}
				}
			}
			foreach (Tile T in Tiles)
			{
				if (T.ID == 1)
				{
					Player.shouldRender = true;
					Player.Position = new Vector2(T.Position.X + 6f, T.Position.Y);
					toDelete = T;
				}
			}
			if (toDelete != null)
			{
				Tiles.Remove(toDelete);
			}
			if (!Changed)
			{
				UpdateMap = true;
			}
			if (Level_Name.Equals(Old_Name))
			{
				Level_Name = Count.ToString();
			}
			Changed = false;
			Player.hasStopped = false;
			Player.Checkpoint = null;
			setRender(Render);
		}

		private void setRender(bool Render)
		{
			foreach (Tile T in Tiles)
			{
				if (T.Type != TileType.Door && T.Type != TileType.Key && T.Type != TileType.PickupGem && T.Type != TileType.PickupPowerup)
				{
					T.shouldRender = Render;
				}
			}
		}

		private string GetPowerName(int ID)
		{
			switch (ID)
			{
			case 0:
				return "None";
			case 1:
				return "FeatherFall";
			case 2:
				return "High Jump";
			case 3:
				return "Colorless";
			default:
				return "None";
			}
		}

		private Texture2D Load(string Asset)
		{
			try
			{
				return base.Content.Load<Texture2D>(Asset) ?? Wall;
			}
			catch
			{
				return Wall;
			}
		}

		public void Player_hitSpike(object sender, EventArgs e)
		{
			if (Player.Checkpoint == null)
			{
				GetLevel(Increment: false);
			}
			else
			{
				Player.Position = new Vector2(Player.Checkpoint.Position.X + 6f, Player.Checkpoint.Position.Y + 4f);
			}
		}

		public void PlaySound(string SoundName)
		{
			SoundEffectInstance Sound = base.Content.Load<SoundEffect>("Sounds//" + SoundName).CreateInstance();
			Sound.Play();
		}

		private void Player_openDoor(object sender, EventArgs e)
		{
			int IDKD = (int)sender;
			foreach (Tile T in Tiles)
			{
				if (T.Type == TileType.Door && T.DoorKeyID == IDKD)
				{
					T.shouldRender = false;
					T.isSolid = false;
				}
				if (T.Type == TileType.Key && T.DoorKeyID == IDKD)
				{
					T.shouldRender = false;
				}
			}
		}

		private void Player_playSound(object sender, EventArgs e)
		{
			string Sound = (string)sender;
			if (Sound == "Gem")
			{
				PlaySound("Pickup");
			}
		}

		private void Player_Toggle(object sender, EventArgs e)
		{
			int[] Position = (int[])sender;
			int X = Position[0];
			int Y = Position[1];
			foreach (Tile T in Tiles)
			{
				if ((int)(T.Position.X / 32f) == X && (int)(T.Position.Y / 32f) == Y)
				{
					if (Position[2] == 0)
					{
						T.Enabled = false;
					}
					else
					{
						T.Enabled = true;
					}
					break;
				}
			}
		}
	}
}
