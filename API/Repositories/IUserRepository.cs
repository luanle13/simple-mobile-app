using API.Models;

namespace API.Repositories
{
    public interface IUserRepository
    {
        Task<User> CreateAsync(User user);
        Task<User> UpdateAsync(User user);
        Task<User?> GetByUsernameAsync(string username);
    }
}
