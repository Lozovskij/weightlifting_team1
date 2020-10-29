using Blazored.SessionStorage;
using Microsoft.AspNetCore.Components.Authorization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;

namespace WeightliftingTeam1.Data
{
    public class CustomAuthenticationStateProvider : AuthenticationStateProvider
    {
        private ISessionStorageService sessionStorageService;
        public CustomAuthenticationStateProvider(ISessionStorageService sessionStorageService)
        {
            this.sessionStorageService = sessionStorageService;
        }
        public override async Task<AuthenticationState> GetAuthenticationStateAsync()
        {
            var role = await sessionStorageService.GetItemAsync<string>("role");
            ClaimsIdentity identity;
            if (role != null)
            {
                identity = new ClaimsIdentity(new[]{
                    new Claim(ClaimTypes.Name, role)
                }, "apiauth_type");
            }
            else
            {
                identity = new ClaimsIdentity();
            } 
            var user = new ClaimsPrincipal(identity);

            return await Task.FromResult(new AuthenticationState(user));
        }

        public void MarkUserAsAuthenticated(string role)
        {
            var identity = new ClaimsIdentity(new[]{
                new Claim(ClaimTypes.Name, role)
            },"apiauth_type");

            var user = new ClaimsPrincipal(identity);

            NotifyAuthenticationStateChanged(Task.FromResult(new AuthenticationState(user)));
        }

        public void MarkUserAsLoggedOut()
        {
            sessionStorageService.RemoveItemAsync("role");

            var identity = new ClaimsIdentity();

            var user = new ClaimsPrincipal(identity);

            NotifyAuthenticationStateChanged(Task.FromResult(new AuthenticationState(user)));
        }
    }
}
