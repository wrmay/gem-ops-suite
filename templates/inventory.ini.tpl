{% for server in Servers %}
{{ server.PublicIpAddress }}
{% endfor %}

[locators]
{% for server in Servers if 'Locator' in server.Roles %}
{{ server.PublicIpAddress }}
{% endfor %}

[datanodes]
{% for server in Servers if 'DataNode' in server.Roles %}
{{ server.PublicIpAddress }}
{% endfor %}

[grinder]
{% for server in Servers if 'Grinder' in server.Roles %}
{{ server.PublicIpAddress }}
{% endfor %}