package ops.app.pa.projmgr;

/**
 * @author pascal
 *
 * To change this generated comment edit the template variable "typecomment":
 * Window>Preferences>Java>Templates.
 * To enable and disable the creation of type comments go to
 * Window>Preferences>Java>Code Generation.
 */

import java.util.Vector;

public class ProjectManager {

	private Vector projects;

	public ProjectManager() {
		this.projects = null;
	}

	/**
	 * Sets the projects.
	 * @param projects The projects to set
	 */
	public void setProjects(Vector projects) {
		this.projects = projects;
	}

	/**
	 * Returns the projects.
	 * @return Vector
	 */
	public Vector getProjects() {
		return projects;
	}

}