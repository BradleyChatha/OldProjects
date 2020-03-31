using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;
using System.Collections.Generic;

namespace J_Platformer
{
	public class Tile
	{
		public Texture2D Texture;

		public Vector2 Position;

		public Color Color;

		public int ID;

		public bool shouldRender = true;

		public bool isSolid;

		public bool Enabled = true;

		public bool canToggle = true;

		public bool setAsDisabled = true;

		public bool startTimer;

		public TileType Type;

		public int Power;

		public int GemScore;

		public int DoorKeyID;

		public int ProjDirection;

		public double TIMER_TIME = 800.0;

		public double _Timer = -1000.0;

		public int lever_X;

		public int lever_Y;

		public Tile()
		{
		}

		public Tile(Texture2D Texture, Vector2 Position, Color Color, int ID, bool isSolid, TileType Type)
		{
			this.Texture = Texture;
			this.Position = Position;
			this.Color = Color;
			this.ID = ID;
			this.isSolid = isSolid;
			this.Type = Type;
		}

		public Tile(Texture2D Texture, Vector2 Position, Color Color, int ID, bool isSolid, TileType Type, int GemScore, int DoorKeyID, int Power)
		{
			this.Texture = Texture;
			this.Position = Position;
			this.Color = Color;
			this.ID = ID;
			this.isSolid = isSolid;
			this.Type = Type;
			this.GemScore = GemScore;
			this.DoorKeyID = DoorKeyID;
			this.Power = Power;
		}

		public void Update(GameTime gameTime, List<Projectile> Projectiles, ref Texture2D Projectile)
		{
			if (Type == TileType.Shooter && Enabled)
			{
				if (_Timer == -1000.0)
				{
					_Timer = TIMER_TIME;
				}
				_Timer -= gameTime.ElapsedGameTime.TotalMilliseconds;
				if (_Timer <= 0.0)
				{
					if (ProjDirection == Direction.Up || ProjDirection == Direction.Down)
					{
						Projectiles.Add(new Projectile(Projectile, new Vector2(Position.X + (float)(Texture.Width / 2) - (float)(Projectile.Width / 2), Position.Y + (float)(Texture.Height / 2)), Color, ProjDirection));
					}
					else
					{
						Projectiles.Add(new Projectile(Projectile, new Vector2(Position.X + (float)(Texture.Width / 2) - (float)(Projectile.Width / 2), Position.Y + (float)(Texture.Height / 2 / 2)), Color, ProjDirection));
					}
					_Timer = TIMER_TIME;
				}
			}
			if (Enabled && startTimer)
			{
				if (_Timer == -1000.0)
				{
					_Timer = TIMER_TIME;
				}
				_Timer -= gameTime.ElapsedGameTime.TotalMilliseconds;
				if (_Timer <= 0.0)
				{
					startTimer = false;
					_Timer = TIMER_TIME;
				}
			}
		}
	}
}
