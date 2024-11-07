using API.Infrastructure;
using API.Models;
using BCrypt.Net;
using Microsoft.EntityFrameworkCore;

namespace API.Services
{
    public class UserService : IUserService
    {
        private readonly ApplicationDbContext _context;

        public UserService(ApplicationDbContext context)
        {
            _context = context;
        }

        public async Task<User?> Authenticate(string username, string password)
        {
            var user = await _context.Users.SingleOrDefaultAsync(x => x.Username == username);
            if (user == null || !BCrypt.Net.BCrypt.Verify(password, user.PasswordHash))
            {
                return null;
            }
            return user;
        }

        public async Task<User?> GetByUsername(string username)
        {
            return await _context.Users.SingleOrDefaultAsync(x => x.Username == username);
        }

        public async Task<User> Create(User user)
        {
            user.PasswordHash = BCrypt.Net.BCrypt.HashPassword(user.PasswordHash);
            _context.Users.Add(user);
            await _context.SaveChangesAsync();
            return user;
        }

        public async Task<User?> Update(string username, User updatedUser)
        {
            var user = await _context.Users.SingleOrDefaultAsync(x=>x.Username == username);
            if (user == null)
            {
                return null;
            }
            user.FullName = updatedUser.FullName;
            user.Email = updatedUser.Email;
            if (!string.IsNullOrEmpty(updatedUser.PasswordHash))
            {
                user.PasswordHash= BCrypt.Net.BCrypt.HashPassword(updatedUser.PasswordHash);
            }
            _context.Users.Update(user);
            await _context.SaveChangesAsync();
            return user;
        }
    }
}
