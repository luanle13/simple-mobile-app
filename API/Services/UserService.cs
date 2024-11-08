using API.DTOs;
using API.Models;
using API.Repositories;
using AutoMapper;

namespace API.Services
{
    public class UserService : IUserService
    {
        private readonly IUserRepository _userRepository;
        private readonly IMapper _mapper;

        public UserService(IUserRepository userRepository, IMapper mapper)
        {
            _userRepository = userRepository;
            _mapper = mapper;
        }

        public async Task<UserDto?> Authenticate(string username, string password)
        {
            var user = await _userRepository.GetByUsernameAsync(username);
            if (user == null || !BCrypt.Net.BCrypt.Verify(password, user.Password)) {
                return null;
            }
            return _mapper.Map<UserDto>(user);
        }

        public async Task<UserDto?> GetByUsername(string username)
        {
            var user = await _userRepository.GetByUsernameAsync(username);
            if (user == null)
            {
                return null;
            }
            return _mapper.Map<UserDto>(user);
        }

        public async Task<UserDto> Register(RegisterDto registerDto)
        {
            var user = _mapper.Map<User>(registerDto);
            user.Password = BCrypt.Net.BCrypt.HashPassword(registerDto.Password);
            await _userRepository.CreateAsync(user);
            return _mapper.Map<UserDto>(user);
        }

        public async Task<UserDto?> UpdateProfile(string username, EditProfileDto editProfileDto)
        {
            var user = await _userRepository.GetByUsernameAsync(username);
            if (user == null)
            {
                return null;
            }
            user.FullName = editProfileDto.FullName;
            user.Email = editProfileDto.Email;
            if (!string.IsNullOrEmpty(editProfileDto.Password))
            {
                user.Password = BCrypt.Net.BCrypt.HashPassword(editProfileDto.Password);
            }
            await _userRepository.UpdateAsync(user);
            return _mapper.Map<UserDto>(user);
        }
    }
}
