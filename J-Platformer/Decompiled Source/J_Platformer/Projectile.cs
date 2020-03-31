using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace J_Platformer
{
	public class Projectile
	{
		public Texture2D Texture;

		public Vector2 Position;

		public Color Color;

		public float Speed = 3f;

		private int Direct;

		public bool shouldRender = true;

		public Projectile(Texture2D Texture, Vector2 Position, Color Color, int Direct)
		{
			this.Texture = Texture;
			this.Position = Position;
			this.Color = Color;
			this.Direct = Direct;
		}

		public void Draw(SpriteBatch spriteBatch)
		{
			spriteBatch.Draw(Texture, Position, Color);
		}

		public void Update(GameTime gameTime, Main Game)
		{
			if (Direct == Direction.Up)
			{
				Position.Y -= Speed;
			}
			if (Direct == Direction.Right)
			{
				Position.X += Speed;
			}
			if (Direct == Direction.Down)
			{
				Position.Y += Speed;
			}
			if (Direct == Direction.Left)
			{
				Position.X -= Speed;
			}
			if (new Rectangle((int)Position.X, (int)Position.Y, Texture.Width, Texture.Height).Intersects(new Rectangle((int)Game.Player.Position.X, (int)Game.Player.Position.Y, Game.Player.Texture.Width, Game.Player.Texture.Height)))
			{
				Game.Player_hitSpike(this, null);
			}
		}
	}
}
