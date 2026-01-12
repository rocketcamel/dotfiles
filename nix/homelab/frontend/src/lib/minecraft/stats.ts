type StatsResponse = {
  status: string;
  players_online: number;
  max_players: number;
  uptime: {
    seconds: number;
    started_at: string;
  };
  world_size: string;
};

export const fetchStats = async () => {
  const response = await fetch("/api/minecraft-server-stats");
  return (await response.json()) as StatsResponse;
};
