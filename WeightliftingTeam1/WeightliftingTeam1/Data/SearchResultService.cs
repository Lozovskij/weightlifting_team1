using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using WeightliftingTeam1.ModelsForOutput;

namespace WeightliftingTeam1.Data
{
    public class SearchResultService
    {   

        List<Attempt> athleteResults = new List<Attempt>()
        {
            new Attempt(){ Id= 1, FullName = "GRIMSLAND Ryan Henry", Nation = "USA", Weight = 66.92, TotalResult = 277},
            new Attempt(){ Id= 2, FullName = "MOLENAAR Yhurisen", Nation = "CUR", Weight = 66.77, TotalResult = 160},
            new Attempt(){ Id= 3, FullName = "RALPH Jantji", Nation = "CUR", Weight = 71.87, TotalResult = 178},
            new Attempt(){ Id= 4, FullName = "ARAQUE Laertes", Nation = "ARU", Weight = 85.83, TotalResult = 246},
            new Attempt(){ Id= 5, FullName = "LAWGUN Isaac Charlie Ng", Nation = "NZL", Weight = 94.67, TotalResult = 297},
            new Attempt(){ Id= 6, FullName = "GRIFFITH Daniel", Nation = "BAR", Weight = 89.55, TotalResult = 255}
        };

        public async Task<List<Attempt>> GetAthleteResults(IAthletesPanel athletesPanel) => await Task.Run(() => athleteResults);

    }
}
