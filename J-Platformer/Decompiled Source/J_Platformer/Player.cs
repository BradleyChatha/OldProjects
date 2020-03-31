using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using Microsoft.Xna.Framework.Input;
using System;
using System.Collections.Generic;

namespace J_Platformer
{
	public class Player
	{
		private const double TIMER_TIME = 500.0;

		public Texture2D Texture;

		public Vector2 Position;

		public Color Color;

		public int ID;

		public int Score;

		public int Ichi;

		public int x;

		public int y;

		private float Speed = 2f;

		private float Gravity = 4f;

		private float JumpSpeed = 4f;

		private double _Timer = 500.0;

		public bool shouldRender;

		public bool onSolidGround;

		public bool hasStopped = true;

		public bool canWalkRight = true;

		public bool canWalkLeft = true;

		public bool canJump = true;

		public bool inAir;

		public bool isMoving;

		public int Powerup;

		public KeyboardState Key;

		public KeyboardState PrevKey;

		public Tile Checkpoint;

		private Rectangle PlayerBottom;

		private Rectangle PlayerTop;

		private Rectangle PlayerRight;

		private Rectangle PlayerLeft;

		public event EventHandler hitSpike;

		public event EventHandler openDoor;

		public event EventHandler playSound;

		public event EventHandler Toggle;

		public Player(Texture2D Texture, Vector2 Position, Color Color, int ID)
		{
			this.Texture = Texture;
			this.Position = Position;
			this.Color = Color;
			this.ID = ID;
			Key = Keyboard.GetState();
		}

		public void Update(GameTime gameTime, List<Tile> Tiles, GraphicsDevice GraphicsDevice, List<Projectile> Projectiles, bool LastMap, ref int PX, ref int PY, ref bool OnGround, ref bool WalkRight, ref bool WalkLeft, ref bool CanJump)
		{
			PrevKey = Key;
			Key = Keyboard.GetState();
			x = (int)Position.X;
			y = (int)Position.Y;
			PlayerBottom = new Rectangle(x + 1, y + Texture.Height + 1, 15, 1);
			PlayerTop = new Rectangle(x + 1, y, 15, 1);
			PlayerRight = new Rectangle(x + Texture.Width, y + 1, 1, 15);
			PlayerLeft = new Rectangle(x - 1, y + 1, -1, 15);
			if (Score != Ichi - 20 && (Score < Ichi || Score > Ichi))
			{
				Score = Ichi - 20;
			}
			for (int i = 0; i < Tiles.ToArray().Length; i++)
			{
				Tile T = Tiles[i];
				Rectangle WallBox = new Rectangle((int)T.Position.X, (int)T.Position.Y, T.Texture.Width, T.Texture.Height);
				if (T.isSolid)
				{
					if (PlayerBottom.Intersects(WallBox))
					{
						onSolidGround = true;
					}
					if (PlayerTop.Intersects(WallBox))
					{
						inAir = false;
					}
					if (PlayerRight.Intersects(WallBox))
					{
						canWalkRight = false;
					}
					if (PlayerLeft.Intersects(WallBox))
					{
						canWalkLeft = false;
					}
					if (onSolidGround)
					{
						canJump = true;
					}
				}
				if (Intersects(2, T, WallBox))
				{
					hasStopped = true;
				}
				if (T.Type == TileType.Killable && Intersects(T.ID, T, WallBox))
				{
					this.hitSpike(this, null);
				}
				if (T.Type == TileType.PickupGem && T.shouldRender && Intersects(T.ID, T, WallBox))
				{
					Score += T.GemScore;
					Ichi = Score + 20;
					T.shouldRender = false;
					this.playSound("Gem", null);
				}
				if (T.Type == TileType.Key && T.shouldRender && Intersects(T.ID, T, WallBox))
				{
					this.openDoor(T.DoorKeyID, null);
				}
				if (T.Type == TileType.PickupPowerup && T.shouldRender && Intersects(T.ID, T, WallBox))
				{
					T.shouldRender = false;
					Powerup = T.Power;
				}
				if (T.Type == TileType.Checkpoint && T.shouldRender && Intersects(T.ID, T, WallBox))
				{
					if (Checkpoint != null && Checkpoint != T)
					{
						Checkpoint.Color = Color.DarkMagenta;
					}
					Checkpoint = T;
					T.Color = Color.Magenta;
				}
				if (T.Type == TileType.Toggleable && T.shouldRender && Intersects(T.ID, T, WallBox) && T.canToggle && !T.startTimer)
				{
					if (T.setAsDisabled)
					{
						this.Toggle(new int[3]
						{
							T.lever_X,
							T.lever_Y,
							0
						}, null);
						T.Color = Color.DarkRed;
						T.startTimer = true;
						T.setAsDisabled = false;
					}
					else
					{
						this.Toggle(new int[3]
						{
							T.lever_X,
							T.lever_Y,
							1
						}, null);
						T.Color = Color.DarkBlue;
						T.startTimer = true;
						T.setAsDisabled = true;
					}
				}
			}
			for (int j = 0; j < Projectiles.ToArray().Length; j++)
			{
				Projectile Project = Projectiles[j];
				if (Project.shouldRender && new Rectangle((int)Project.Position.X, (int)Project.Position.Y, Project.Texture.Width, Project.Texture.Height).Intersects(new Rectangle((int)Position.X, (int)Position.Y, Texture.Width, Texture.Height)))
				{
					this.hitSpike(this, null);
				}
			}
			if (Powerup == Powerups.FeatherFall)
			{
				Gravity = 2f;
			}
			else
			{
				Gravity = 4f;
			}
			if (!inAir && Powerup == Powerups.High_Jump)
			{
				_Timer = 800.0;
			}
			else if (!inAir)
			{
				_Timer = 500.0;
			}
			if (Powerup == Powerups.Colorless)
			{
				Color.R = 0;
				Color.B = 0;
				Color.G = 0;
			}
			else
			{
				Color = Color.White;
			}
			if (Position.Y > (float)GraphicsDevice.Viewport.Height)
			{
				Position.Y = -16f;
			}
			if (Position.X >= (float)(GraphicsDevice.Viewport.Width - 2))
			{
				Position.X = -13f;
				Position.Y -= Gravity;
			}
			if (Position.X < -15f)
			{
				Position.X = GraphicsDevice.Viewport.Width - 5;
				Position.Y -= Gravity;
			}
			if (Position.Y < -17f)
			{
				Position.Y = GraphicsDevice.Viewport.Width + 14;
			}
			if (!onSolidGround && !inAir)
			{
				Position.Y += Gravity;
			}
			if ((Keyboard.GetState().IsKeyDown(Keys.Left) && canWalkLeft && !LastMap) || (Keyboard.GetState().IsKeyDown(Keys.Left) && canWalkLeft && LastMap))
			{
				Position.X -= Speed;
				isMoving = true;
			}
			if ((Keyboard.GetState().IsKeyDown(Keys.Right) && canWalkRight && Position.X < (float)GraphicsDevice.Viewport.Width && !LastMap) || (Keyboard.GetState().IsKeyDown(Keys.Right) && canWalkRight && LastMap))
			{
				Position.X += Speed;
				isMoving = true;
			}
			if (Keyboard.GetState().IsKeyDown(Keys.Up) && canJump && onSolidGround && PrevKey.IsKeyUp(Keys.Up))
			{
				inAir = true;
				isMoving = true;
			}
			if (Position.X % 2f == 1f)
			{
				Position.X += 1f;
			}
			if (inAir)
			{
				_Timer -= gameTime.ElapsedGameTime.TotalMilliseconds;
				if (_Timer > 0.0)
				{
					Position.Y -= JumpSpeed;
				}
			}
			if (_Timer < 0.0)
			{
				inAir = false;
				_Timer = 500.0;
			}
			if (!canJump && !canWalkLeft && !canWalkRight && onSolidGround)
			{
				Position.Y += Texture.Height;
			}
			PX = (int)Position.X;
			PY = (int)Position.Y;
			OnGround = onSolidGround;
			WalkLeft = canWalkLeft;
			WalkRight = canWalkRight;
			CanJump = inAir;
			onSolidGround = false;
			canWalkRight = true;
			canWalkLeft = true;
			canJump = true;
			if (!inAir)
			{
				_Timer = 500.0;
			}
		}

		private bool Intersects(int ID, Tile T, Rectangle WallBox)
		{
			if ((T.ID == ID && PlayerBottom.Intersects(WallBox)) || (T.ID == ID && PlayerLeft.Intersects(WallBox)) || (T.ID == ID && PlayerTop.Intersects(WallBox)) || (T.ID == ID && PlayerRight.Intersects(WallBox)))
			{
				return true;
			}
			return false;
		}
	}
}
