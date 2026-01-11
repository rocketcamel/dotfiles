type StatsResponse = {
  status: string;
  players_online: number;
  max_players: number;
  uptime: string;
  world_size: string;
};

export const fetchStats = async () => {
  const response = await fetch(
    "http://localhost:5173/api/minecraft-server-stats",
  );
  return (await response.json()) as StatsResponse;
};
