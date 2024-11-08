using API.DTOs;
using API.Models;

namespace API.Services
{
    public interface IUserService
    {
        Task<UserDto> Register(RegisterDto registerDto);
        Task<UserDto?> Authenticate(string username, string password);
        Task<UserDto?> GetByUsername(string username);
        Task<UserDto?> UpdateProfile(string username, EditProfileDto editProfileDto);
    }
}
