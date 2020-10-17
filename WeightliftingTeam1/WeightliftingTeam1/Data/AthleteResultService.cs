using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WeightliftingTeam1.Data
{
    public class AthleteResultService
    {
        List<AthleteResult> athleteResults = new List<AthleteResult>()
        {
            new AthleteResult(){ Id= 1, FullName = "GRIMSLAND Ryan Henry", Nation = "USA", Weight = 66.92, TotalResult = 277},
            new AthleteResult(){ Id= 2, FullName = "MOLENAAR Yhurisen", Nation = "CUR", Weight = 66.77, TotalResult = 160},
            new AthleteResult(){ Id= 3, FullName = "RALPH Jantji", Nation = "CUR", Weight = 71.87, TotalResult = 178},
            new AthleteResult(){ Id= 4, FullName = "ARAQUE Laertes", Nation = "ARU", Weight = 85.83, TotalResult = 246},
            new AthleteResult(){ Id= 5, FullName = "LAWGUN Isaac Charlie Ng", Nation = "NZL", Weight = 94.67, TotalResult = 297},
            new AthleteResult(){ Id= 6, FullName = "GRIFFITH Daniel", Nation = "BAR", Weight = 89.55, TotalResult = 255}
        };
        public async Task<List<AthleteResult>> GetAthleteResults()
        {
            return await Task.Run(() => athleteResults);
        }
    }
}
