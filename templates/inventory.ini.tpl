{% for server in Servers %}
{{ server.PrivateIP }}
{% endfor %}

[locators]
{% for server in Servers if 'Locator' in server.Roles %}
{{ server.PrivateIP }}
{% endfor %}

[datanodes]
{% for server in Servers if 'DataNode' in server.Roles %}
{{ server.PrivateIP }}
{% endfor %}

[grinder]
{% for server in Servers if 'Grinder' in server.Roles %}
{{ server.PrivateIP }}
{% endfor %}