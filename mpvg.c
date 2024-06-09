#include <gtk/gtk.h>
#include <stdlib.h>
#include <string.h>

GtkWidget *user_entry;
GtkWidget *host_entry;
GtkWidget *port_entry;

void execute_command(const char *command) {
    const char *user = gtk_entry_get_text(GTK_ENTRY(user_entry));
    const char *host = gtk_entry_get_text(GTK_ENTRY(host_entry));
    const char *port = gtk_entry_get_text(GTK_ENTRY(port_entry));

    char ssh_command[256];
    snprintf(ssh_command, sizeof(ssh_command), "ssh -p %s %s@%s 'mpv.sh %s'", port, user, host, command);
    system(ssh_command);
}

void on_button_clicked(GtkWidget *widget, gpointer data) {
    const char *command = (const char *)data;
    execute_command(command);
}

int main(int argc, char *argv[]) {
    gtk_init(&argc, &argv);

    GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    gtk_window_set_title(GTK_WINDOW(window), "MPV Player");
    gtk_container_set_border_width(GTK_CONTAINER(window), 10);

    GtkWidget *grid = gtk_grid_new();
    gtk_grid_set_column_homogeneous(GTK_GRID(grid), TRUE);
    gtk_container_add(GTK_CONTAINER(window), grid);

    user_entry = gtk_entry_new();
    host_entry = gtk_entry_new();
    port_entry = gtk_entry_new();

    gtk_entry_set_text(GTK_ENTRY(user_entry), getenv("USER"));
    gtk_entry_set_text(GTK_ENTRY(host_entry), "localhost");
    gtk_entry_set_text(GTK_ENTRY(port_entry), "22");

    // Set the width of the entries to be half the default width
    gtk_entry_set_width_chars(GTK_ENTRY(user_entry), 7);
    gtk_entry_set_width_chars(GTK_ENTRY(host_entry), 7);
    gtk_entry_set_width_chars(GTK_ENTRY(port_entry), 7);

    gtk_grid_attach(GTK_GRID(grid), user_entry, 0, 0, 1, 1);
    gtk_grid_attach(GTK_GRID(grid), gtk_label_new("@"), 1, 0, 1, 1);
    gtk_grid_attach(GTK_GRID(grid), host_entry, 2, 0, 1, 1);
    gtk_grid_attach(GTK_GRID(grid), gtk_label_new(":"), 3, 0, 1, 1);
    gtk_grid_attach(GTK_GRID(grid), port_entry, 4, 0, 1, 1);

    GtkWidget *buttons[7];
    const char *labels[7] = {"⏪", "▶️", "⏩", "⏬", "⏫", "🔉", "🔊"};
    const char *commands[7] = {"-b", "-p", "-n", "-sd", "-su", "-vd", "-vu"};

    for (int i = 0; i < 7; i++) {
        buttons[i] = gtk_button_new_with_label(labels[i]);
        g_signal_connect(buttons[i], "clicked", G_CALLBACK(on_button_clicked), (gpointer)commands[i]);
        gtk_grid_attach(GTK_GRID(grid), buttons[i], i, 1, 1, 1);
    }

    g_signal_connect(window, "destroy", G_CALLBACK(gtk_main_quit), NULL);

    gtk_widget_show_all(window);
    gtk_main();

    return 0;
}
