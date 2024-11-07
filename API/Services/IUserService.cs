using API.Models;

namespace API.Services
{
    public interface IUserService
    {
        Task<User> Create(User user);
        Task<User?> Authenticate(string username, string password);
        Task<User?> GetByUsername(string username);
        Task<User?> Update(string username, User updatedUser);
    }
}
