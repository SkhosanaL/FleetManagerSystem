function updateDateTime() {
  const now = new Date();
  const options = { year: 'numeric', month: 'long', day: 'numeric', weekday: 'long' };
  const dateString = now.toLocaleDateString(undefined, options);
  const timeString = now.toLocaleTimeString();

  document.getElementById('datetime').innerHTML = `${dateString} | ${timeString}`;
}

function viewVehicles() {
  window.location.href = "/public/index.html";
}

function viewEmployees() {
  alert("VIEW EMPLOYEES clicked");
}

function viewDrivers() {
  alert("VIEW DRIVERS clicked");
}

function viewTrips() {
  alert("VIEW TRIPS clicked");
}

function vehicleMaintenance() {
  alert("VEHICLE MAINTENANCE clicked");
}

function fuelLogs() {
  alert("FUEL LOGS clicked");
}

function updateUsers() {
  alert("UPDATE USERS clicked");
}

function processSalaries() {
  alert("PROCESS SALARIES clicked");
}
function closeForm() {
  // Logic to close the form
  window.close();
}
// Update the date and time every second
setInterval(updateDateTime, 1000);

// Initialize the date and time on page load
updateDateTime();
