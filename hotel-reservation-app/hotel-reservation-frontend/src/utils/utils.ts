export function formatDateString(date: string) {
  return date.split("T")[0];
}

export function formatDate(date: Date) {
  return formatDateString(date.toISOString());
}

