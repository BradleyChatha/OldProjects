using Microsoft.Xna.Framework.Content;
using System;
using System.IO;

namespace J_Platformer
{
	internal static class Program
	{
		private static void Main(string[] args)
		{
			try
			{
				using (Main game = new Main())
				{
					game.Run();
				}
			}
			catch (ContentLoadException ex2)
			{
				File.WriteAllLines("Content_Load_Error.txt", new string[4]
				{
					ex2.Message,
					ex2.StackTrace,
					ex2.InnerException.Message,
					ex2.InnerException.StackTrace
				});
			}
			catch (Exception ex)
			{
				File.WriteAllText("Error.txt", ex.Message + ex.StackTrace);
			}
		}
	}
}
